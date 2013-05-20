define ['bootstrap/bootstrap-typeahead'], ->
	window.DELAY = 100

	###
	Manages form to search for and add foursquare venues to a Listen.ItemCollection
	###
	class SearchView extends Parse.View
		template: 'search2'

		tagName: 'form'
		className: 'foursquare one-line'

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
					venue = @venues.find (item) -> item.name is name
					# add a new Listen.Item to the collection and save it
					item = @options.list.addFromSource('foursquare', venue)
					console.log item
					item.save()
					# return name, what the typeahead expects
					name

		# calls foursquare to turn query string into list of potential venues
		search: (query, callback) ->
			evt?.preventDefault()
			@timeout = undefined

			callback = if _.isFunction(callback) then callback else @success

			near = @$('#near').val().trim()

			# if location has changed then do a venue search to geocode result
			if near isnt @_geocode?.where
				Parse.Cloud.run 'venueSearch', { query: query, near: near, limit: 8 },
					success: (response) =>
						window.response = JSON.parse(response).response
						# update cached geocode, keep it fresh
						@_geocode = window.response.geocode
						callback window.response.venues
					error: @error
			# otherwise use faster venue completion API for typing in the text box
			else
				# use cached geocode coordinates for lat-lng location search
				center = @_geocode.feature.geometry.center
				Parse.Cloud.run 'venueCompletion', { query: query, ll: center.lat + ',' + center.lng, limit: 8 },
					success: (response) =>
						response = JSON.parse(response).response
						callback response.minivenues

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

		# TODO: unused
		error: (error) =>
			@$('#submit').removeClass 'load'
			console.error error
			# TODO: error message spot
			$('#list').html JST.error
				message: error.message
				icon: 'remove'


