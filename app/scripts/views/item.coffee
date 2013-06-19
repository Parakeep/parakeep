define ->
	###
	View for a single item in a list. Be sure to pass template and className to constructor.
	###
	class ItemView extends Backbone.View
		# template: 'items/business'

		tagName: 'li'

		serialize: -> @model.toJSON()