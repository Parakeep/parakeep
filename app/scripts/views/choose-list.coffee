define ['models/listen', 'views/message'], (Listen, MessageView) ->
	class ChooseListView extends Backbone.View
		template: 'choose-list'

		events:
			'click #back'  : 'goodbye'
			'click li'     : 'toggleList'
			'submit form'  : 'createList'
			'keyup #title' : 'toggleForm'
			'blur #title'  : 'toggleForm'
			'click #ok'    : 'omgAddTime'

		initialize: ->
			@userLists = new Listen.ListCollection()
			@userLists.query = new Parse.Query(Listen.List).equalTo('user', Parse.User.current())
			@userLists.on 'all', @render, @
			@userLists.fetch()
			window.userLists = @userLists

		serialize: ->
			lists: @userLists.models

		afterRender: ->
			$('#offscreen').addClass('onscreen')
			@$('#ok').css 'visibility', 'hidden'

		toggleList: (e) ->
			$(e.currentTarget).toggleClass('added')
			@$('#ok').css 'visibility', if $('.added').size() then 'visible' else 'hidden'

		createList: (e) ->
			e.preventDefault()
			list = new Listen.List
				title: @$('#title').val().trim()
				tagline: @$('#tagline').val().trim()
				user: Parse.User.current()
			list.save()
			@userLists.add list, at: 0
			# @$('li:first-child').addClass('added')

		toggleForm: (e) ->
			if @$('#title').val()
				@$('#tagline').removeClass 'hide'
			else
				@$('#tagline').addClass 'hide'

		# slides the panel away and then removes from the DOM
		goodbye: =>
			setTimeout (=> @remove()), 1000
			$('#offscreen').removeClass('onscreen')

		# OMG! adds the item to the selected lists!
		omgAddTime: (e) ->
			# get list objects using data-cid attribute
			targetLists = _.map @$('.added'), (el) ->
				@userLists.getByCid(el.getAttribute('data-cid'))
			# add those lists to the item's lists relation
			@model.relation('lists').add(targetLists)
			# save the F out of it, showing a nice message when done
			@model.save { user: Parse.User.current() },
				success: (item) =>
					message = new MessageView
						message: 'message-added'
						params:
							name: item.get('data').name
							lists: targetLists.map (item) -> title: item.get('title')
					message.modal().done @goodbye
				error: (item, error) =>
					# TODO: error handling
					console.error error

