define ['models/listen', 'views/item', 'views/search'], (Listen, ItemView, SearchView) ->
	###
	View for a list of items. Pass Listen.List as parameter model, view gets item collection
	and binds events to manage changes. Contains SearchView for finding and adding businesses
	to the collection.
	###
	class ListView extends Parse.View
		template: 'list'
		itemTemplate: 'items/business'
		itemClassName: 'item'

		initialize: ->
			# cache selectors
			@input = @$('#newItem')
			@listEl = @$('#list')

			# update UI when model changes (infrequent, rename or something)
			@model.on 'change', @render, @

			# create a collection that loads ListItems from this list
			@list = @model.items()
			# collection event to update UI
			@list.bind 'all', @render, @
			# and kick it off!
			@list.fetch()

			# create and cache SearchView to add items to the ItemCollection
			@seachView = new SearchView
				list: @list


		serialize: -> @model.toJSON()

		beforeRender: ->
			@setView '#search', @seachView
			# Iterate over the passed collection and create a view for each item.
			@list?.each (model) =>
				# Pass the sample data to the new SomeItem View.
				@insertView '#list', new ItemView
					model: model
					template: @itemTemplate
					className: @itemClassName

		# TODO: unused, kept for posterity from original listen-parse
		createNewItem: ->
			acl = new Parse.ACL(Parse.User.current())
			acl.setPublicReadAccess(true)
			acl.setPublicWriteAccess(false)
			
			@list.create
				content: @input.val().trim()
				order:   @list.nextOrder()
				list:    @model
				user:    Parse.User.current()
				ACL:     acl
			
			# creating an item triggers the 'add' event bound above
			@input.val('')
