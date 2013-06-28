define ['views/list', 'views/item', 'views/new-list', 'models/listen'], (ListView, ItemView, NewListView, Listen) ->
	###
	The Main Page, shows a list of all public lists.
	###
	class IndexView extends ListView
		# template: 'list'
		itemTemplate: 'items/list'
		itemClassName: 'item'

		initialize: ->
			# query to grab all public lists!
			# TODO: filter by user's friends
			@list = new Parse.Query(Listen.List).equalTo('private', false).collection()
			@list.bind 'all', @render, @
			@list.fetch()

		serialize: ->
			list:
				title: 'All Public Lists'
				