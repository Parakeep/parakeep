define ['app'], (app) ->  

	###
	A kickass library defining List and Item models and collections.

	Listen.List defines a list with a title, tagline, user creator, and privacy state. Does not contain items directly,
	instead provides items() function to create Listen.ItemCollection to fetch relevent items.
	
	Listen.Item defines an item appearing in a list with a data object for arbitrary data from an external source.

	Listen.ItemCollection defines a collection of Listen.Items, to be stored within a Listen.List object. Preferred usage
	is calling Listen.List.items() to create and properly configure a Listen.ItemCollection for a Listen.List.

	Listen.ListCollection defines a collection of Listen.Lists but is pretty unnecessary if you use 
	Parse.Query(Listen.List).collection() to fetch a set of Lists.
	###

	PrivacyTypes = 
		PRIVATE: 'private'
		PUBLIC : 'public'
		SHARED : 'shared'

	Listen = {}
	
	# model for a list itself
	Listen.List = Parse.Object.extend
		className: 'List'

		defaults: 
			user: ''
			title: ''
			tagline: ''
			private: false
			collaborative: false

		items: ->
			return @_items if @_items
			# return @get('items') if @get('items')
			@_items = Listen.createItemCollection @
			# @set 'items', items = new Listen.ItemCollection(list: @)
			@_items

		createItem: (options) ->
			_.extend options, list: @
			@items().create options

	# model for an item in a list
	Listen.Item = Parse.Object.extend
		className: 'ListItem'

		defaults:
			source: ''
			data: ''
			order: 0

		comparator: (item) -> item.get('createdAt')


	# collection of items in a list (contained within List?)
	Listen.ItemCollection = Parse.Collection.extend
		model: Listen.Item

		addFromSource: (source, data) ->
			model = new Listen.Item
				list: @list
				source: source
				data: data
				order: @nextOrder()
			@add model
			model

		# We keep the ListItems in sequential order, despite being saved by unordered
		# GUID in the database. This generates the next order number for new items.
		nextOrder: -> if @length then @last().get('order') + 1 else 1

		# list items are sorted by their original insertion order.
		comparator: (item) -> item.get('order')

	Listen.ListCollection = Parse.Collection.extend
		model: Listen.List

	Listen.createItemCollection = (list) ->
		collection = new Listen.ItemCollection()
		collection.list = list
		collection.query = new Parse.Query(Listen.Item)
		collection.query.equalTo('list', list).include 'user'
		collection

	Listen
