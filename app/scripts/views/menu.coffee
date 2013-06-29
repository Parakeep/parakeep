define ->
	###
	Manages the Menu to the left of the main frame.
	###
	class MenuView extends Backbone.View
		template: 'menu'
		className: 'menu'

		events:
			'click a': 'hideMenu'

		hideMenu: ->
			$('#layout').removeClass('menu-open')
			@