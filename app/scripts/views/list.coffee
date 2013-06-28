define ['models/listen', 'views/item', 'views/search'], (Listen, ItemView, SearchView) ->
	###
	View for a list of items. Pass Listen.List as parameter model, view gets item collection
	and binds events to manage changes. Contains SearchView for finding and adding businesses
	to the collection.
	###
	class ListView extends Backbone.View
		template: 'list'
		itemTemplate: 'items/minivenue'
		itemClassName: 'business item'

		initialize: ->
			if @options.itemTemplate
				@itemTemplate = @options.itemTemplate

			# cache selectors
			@input = @$('#newItem')
			@listEl = @$('#list')

			# if a List model is given then get the collection from it
			if @model
				# update UI when model changes (infrequent, rename or something)
				@model.on 'change', @render, @
				# create a collection that loads ListItems from this list
				@list = @model.items()
				# and kick it off!
				@list.fetch()
			# otherwise if 'list' collection option is given, just use that
			else if @options.list
				@list = @options.list
				
			# collection event to update UI
			@list.bind 'all', @render, @


		serialize: -> 
			list: if @model then @model.toJSON() else title: ''

		beforeRender: ->
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
