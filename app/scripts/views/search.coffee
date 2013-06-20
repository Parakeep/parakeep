define ->
	###
	Manages the Navbar at the top of the frame.
	Not a lot going on here now. 
	###
	class SearchView extends Backbone.View
		template: 'search-tabs'

		# inserted into #navbar so add .navbar-inner to this View's el
		className: 'search'

		afterRender: ->
			@$input = @$('#query')
			@$input.attr('placeholder', @formData.query.placeholder)

		events:
			'click .nav-tabs a': 'changeTab'
			'submit form': 'submit'

		formData:
			query: 
				placeholder: 'Find a business or vendor'
			near: 
				placeholder: 'Search near a location'
			user: 
				placeholder: 'Search your friends'

		defaultParams:
			limit: 8
			intent: 'browse'

		changeTab: (evt) ->
			evt.preventDefault()
			$tgt = $(evt.currentTarget)
			oldTab = @$('.active').data('name')
			newTab = $tgt.parent().data('name')
			$input = @$('#' + oldTab)

			# save input value
			@formData[oldTab].value = $input.val()
			@$('.active span').text($input.val())

			$input.addClass('hide')
			@$('#' + newTab).removeClass('hide').focus()

			$tgt.parent().takeClass('active', '#search')

		getQueryParams: ->
			promise = $.Deferred()
			query = @$('#query').val().trim()
			near = @$('#near').val().trim()
			if near
				return promise.resolve _.extend @defaultParams, { query: query, near: near }
			else
				navigator.geolocation.getCurrentPosition (position) =>
					promise.resolve _.extend @defaultParams,
						query: query
						ll: "#{position.coords.latitude},#{position.coords.longitude}"
				, (error) ->
					promise.reject which: 'near'

			return promise.promise()

		submit: (evt) ->
			evt.preventDefault()
			promise = @getQueryParams()
			promise.done (params) =>
				Parse.Cloud.run 'venueSearch', params,
					success: (response) =>
						window.response = JSON.parse(response).response
						# update cached geocode, keep it fresh
						if window.response.geocode
							@_geocode = window.response.geocode.feature
							@$('#enter-near span').text(@_geocode.displayName)
							@$('#near').val(@_geocode.displayName)
						@success window.response.venues
					error: @error
			promise.fail (error) =>
				if error.which is 'near'
					@$('#enter-near').click()
					@$('#near').attr('placeholder', 'Please enter a location for this search...')

		success: (venues) ->
			@$('#submit').removeClass 'load'

			@options.list.reset _.map venues, (venue) ->
				source: 'foursquare'
				data: venue
				

			# @options.list.create
			# # TODO: how to add to the list? collection!
			# list = $('#contents').html('')
			# if venues.length
			# 	list.append(JST['items/business'] venue) for venue in venues
			# else
			# 	list.html JST.error 
			# 		message: "No results found"
			# 		icon: 'remove'

		error: (error) =>
			console.error error


