define ['app', 'views/choose-list'], (Parakeep, ChooseListView) ->
	###
	View for a single item in a list. Be sure to pass template and className to constructor.
	###
	class ItemView extends Backbone.View

		tagName: 'li'

		serialize: -> @model.toJSON()

		events:
			'movestart': 'allowScroll'
			'click #add': 'addToList'
			'click button': 'menuButton'
			'swiperight': 'toggleMenu'
			'swipeleft': 'toggleMenu'
			'click .icon-swipe': 'toggleMenu'

		toggleMenu: (e) ->
			if @$el.hasClass('menu-open')
				@$el.removeClass('menu-open')
			else @$el.takeClass('menu-open')
			return false
			
		menuButton: (evt) ->
			return false

		allowScroll: (e) ->
			# If the movestart heads off in a upwards or downwards
			# direction, prevent it so that the browser scrolls normally.
			if ((e.distX > e.distY and e.distX < -e.distY) or
			    (e.distX < e.distY and e.distX > -e.distY))
				e.preventDefault()

		addToList: (e) ->
			e.preventDefault()
			Parakeep.layout.setView('#offscreen', 
				@choose = new ChooseListView(model: @model)).render()