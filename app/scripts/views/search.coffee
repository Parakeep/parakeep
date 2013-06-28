define ->
	###
	Manages the search panel on #/search. Handles querying foursquare and displaying results.
	###
	class SearchView extends Backbone.View
		template: 'search-tabs'

		className: 'search'

		serialize: -> @options

		afterRender: ->
			if @options.what and @options.where
				@submit()

		events:
			'click .nav-tabs a': 'changeTab'
			'submit form': 'submit'

		# default foursquare query params
		defaultParams:
			limit: 8
			intent: 'browse'

		changeTab: (evt) ->
			evt.preventDefault()
			# variables!
			$tgt = $(evt.currentTarget)
			oldTab = @$('.active').data('name')
			newTab = $tgt.parent().data('name')
			$input = @$('#' + oldTab)
			# save input value
			@$('.active span').text($input.val())
			# hide old input, show new one
			$input.addClass('hide')
			@$('#' + newTab).removeClass('hide').focus()
			# change active tab
			$tgt.parent().takeClass('active', '#search')

		getQueryParams: ->
			promise = $.Deferred()
			query = @$('#query').val().trim()
			near = @$('#near').val().trim()
			if near
				# if user provided location string then we're donezo
				return promise.resolve _.extend @defaultParams, { query: query, near: near }
			else
				# if not, we'll have to request their current location
				navigator.geolocation.getCurrentPosition (position) =>
					promise.resolve _.extend @defaultParams,
						query: query
						ll: "#{position.coords.latitude},#{position.coords.longitude}"
				, (error) ->
					# if user rejects the request then prompt them to enter text
					promise.reject which: 'near'

			return promise.promise()

		submit: (evt) ->
			evt?.preventDefault()
			# get query params (and current location if needed)
			promise = @getQueryParams()
			promise.done (params) =>
				Backbone.history.navigate "/search/#{params.query}/#{params.near}"
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
			# if user didn't put location and refused to share current then make them enter one.
			promise.fail (error) =>
				if error.which is 'near'
					@$('#enter-near').click()
					@$('#near').attr('placeholder', 'Please enter a location for this search...')

		success: (venues) ->
			# TODO: make this work
			@$('#submit').removeClass 'load'

			# reset list collection with the venues we just fetched, 
			# but map them into appropriate item format.
			@options.list.reset _.map venues, (venue) ->
				source: 'foursquare'
				data: venue

		error: (error) =>
			console.error error


