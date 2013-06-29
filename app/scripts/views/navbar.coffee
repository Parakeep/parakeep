define ->
	###
	Manages the Navbar at the top of the frame.
	###
	class NavbarView extends Backbone.View
		template: 'navbar'

		# inserted into #navbar so add .navbar-inner to this View's el
		className: 'navbar-inner'

		events:
			'click #menu': 'toggleMenu'

		toggleMenu: ->
			$('#layout').toggleClass('menu-open')

		setTitle: (title) ->
			@$('.brand a').text if title then title else 'Parakeep'
