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

		# returns a Listen.ItemCollection configured to fetch items in this list.
		# all that needs to be done is call fetch() on the collection.
		items: ->
			# we are creating a relation on the item storing the lists it belongs to.
			# Parse automatically searches through the relation to find items that belong to
			# this List. Bitchin'!
			new Parse.Query(Listen.Item).equalTo('lists', @).include('user').collection()

		# creates a new item in this list, injecting the correct list reference
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

		# sort by time
		comparator: (item) -> item.get('createdAt')


	# collection of items in a list (contained within List?)
	class Listen.ItemCollection extends Parse.Collection
		model: Listen.Item

		# override Collection.create to inject list and order fields
		create: (options) ->
			super _.extend options, 
				list: @list
				order: @nextOrder()

		# We keep the ListItems in sequential order, despite being saved by unordered
		# GUID in the database. This generates the next order number for new items.
		nextOrder: -> if @length then @last().get('order') + 1 else 1

		# list items are sorted by their original insertion order.
		comparator: (item) -> item.get('order')

	Listen.ListCollection = Parse.Collection.extend
		model: Listen.List

	Listen
