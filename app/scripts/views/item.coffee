define ->
	###
	View for a single item in a list. Be sure to pass template and className to constructor.
	###
	class ItemView extends Backbone.View

		tagName: 'li'

		serialize: -> @model.toJSON()

		events:
			'movestart': 'allowScroll'
			'click button': 'menuButton'
			'swiperight .swipe-menu': 'closeMenu'
			'swipeleft': 'openMenu'
			'click': 'closeMenu'

		openMenu: (evt) ->
			@$el.addClass('menu-open')

		closeMenu: (evt) ->
			@$el.removeClass('menu-open')

		menuButton: (evt) ->
			return false

		allowScroll: (e) ->
			# If the movestart heads off in a upwards or downwards
			# direction, prevent it so that the browser scrolls normally.
			if ((e.distX > e.distY and e.distX < -e.distY) or
			    (e.distX < e.distY and e.distX > -e.distY))
				e.preventDefault()