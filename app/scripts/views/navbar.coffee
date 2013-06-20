define ->
	###
	Manages the Navbar at the top of the frame.
	Not a lot going on here now. 
	###
	class NavbarView extends Backbone.View
		template: 'navbar'

		# inserted into #navbar so add .navbar-inner to this View's el
		className: 'navbar-inner'

		events:
			'click #menu': 'toggleMenu'

		toggleMenu: ->
			$('#layout').toggleClass('menu-open')