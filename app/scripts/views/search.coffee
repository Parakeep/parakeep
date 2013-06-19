define ['bootstrap/bootstrap-typeahead', 'bootstrap/bootstrap-modal'], ->
	window.DELAY = 100

	###
	Manages form to search for foursquare venues and add them to a Listen.ItemCollection
	###
		template: 'search2'
	class SearchView extends Backbone.View

		className: 'foursquare-modal'

		events:
			'submit form': 'createItem'

		serialize: ->
			# preserve user-entered location
			near: @_geocode?.displayName or 'seattle'

		afterRender: ->
			# turn the query field into a bootstrap typeahead
			@$('#query').typeahead
				minLength: 3
				# data source is foursquare search
				source: (query, callback) =>
					@search query, (venues) => 
						if venues.length
							# cache the underscore-wrapped array of venues
							@venues = _(venues)
							# return all the venue names
							callback _.pluck venues, 'name'
						else callback [JST.error(message: 'No Results')]
				matcher: -> true
				highlighter: (name) => 
					# find the venue with the given name and render it as minivenue
					JST['items/minivenue'] @venues.find (item) -> item.name is name
				updater: (name) => 
					# remember chosen venue data so we can save it later
					@venue = @venues.find (item) -> item.name is name
					# render business card into data
					# TODO: unhack-ify?
					@$('#data').css(height: 'auto')		# let #data autosize itself now
						.html($('<div>').addClass('business').html JST['items/business'] data: @venue)
						.append JST['items/flavor']()	# append textarea after business card
					@$('textarea').focus()
					name

		# calls foursquare to turn query string into list of potential venues
		search: (query, callback) ->
			evt?.preventDefault()
			@timeout = undefined

			callback = if _.isFunction(callback) then callback else @success

			near = @$('#near').val().trim()

			# if location has changed then do a venue search to geocode result
			if near isnt @_geocode?.displayName
				Parse.Cloud.run 'venueSearch', { query: query, near: near, limit: 8 },
					success: (response) =>
						window.response = JSON.parse(response).response
						# update cached geocode, keep it fresh
						@_geocode = window.response.geocode.feature
						@$('#near').val(@_geocode.displayName)
						callback window.response.venues
					error: @error
			# otherwise use faster venue completion API for typing in the text box
			else
				# use cached geocode coordinates for lat-lng location search
				center = @_geocode.geometry.center
				Parse.Cloud.run 'venueCompletion', { query: query, ll: center.lat + ',' + center.lng, limit: 8 },
					success: (response) =>
						response = JSON.parse(response).response
						callback response.minivenues
					error: @error

		# display error message in #data
		# TODO: better error messages. foursquare gives generic with error codes
		error: (error) =>
			$('#data').html JST.error
				message: error.message
				icon: 'remove'

		# creates a new item from the modal form and appends it to the item collection
		createItem: (evt) ->
			evt.preventDefault()
			# hide the modal
			@$('#addModal').modal('hide')
			# create the new list item using saved venue info and flavor text
			@options.list.create
				source: 'foursquare'
				data: @venue
				note: @$('#flavor').val()
				user: Parse.User.current()

		# TODO: unused, but useful timeout gating code to limit number of calls to 4sq
		keypress: (e) ->
			if e.keyCode is 13 then @search()
			else
				console.log "keypress #{e.keyCode}"
				if @timeout then window.clearTimeout @timeout
				@timeout = window.setTimeout @autosearch, window.DELAY
				# console.log 'setting timeout', @timeout

		# TODO: unused
		autosearch: =>
			query = @$('#query').val()
			if query.length < 3 then return $('#autocomplete').hide()
			unless query is @_lastQuery
				@_lastQuery = query
				@search()

		# TODO: unused
		success: (venues) ->
			@$('#submit').removeClass 'load'
			# TODO: how to add to the list? collection!
			list = $('#autocomplete').show().html('')
			if venues.length
				list.append(JST['items/business'] venue) for venue in venues
			else
				list.html JST.error 
					message: "No results found"
					icon: 'remove'



