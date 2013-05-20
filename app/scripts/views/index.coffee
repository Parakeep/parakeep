define ['views/list', 'views/item', 'views/new-list', 'models/listen'], (ListView, ItemView, NewListView, Listen) ->
	###
	The Main Page, shows a list of all public lists.
	###
	class IndexView extends Parse.View
		template: 'list'
		itemTemplate: 'items/list'
		itemClassName: 'list'

		initialize: ->
			@lists = new Parse.Query(Listen.List).equalTo('private', false).collection()
			@lists.bind 'all', @render, @
			@lists.fetch()

		serialize: ->
			title: 'All Public Lists'

		beforeRender: ->
			@setView '#search', new NewListView()
			# Iterate over the passed collection and create a view for each item.
			@lists?.each (model) =>
				# Pass the sample data to the new SomeItem View.
				@insertView '#list', new ItemView
					model: model
					template: @itemTemplate
					className: @itemClassName