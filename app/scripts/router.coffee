define ['app', 'views/menu', 'views/navbar', 'views/search', 'views/index', 'views/list', 'views/login', 'views/user', 'models/listen'],
(Parakeep, MenuView, NavbarView, SearchView, IndexView, ListView, LoginView, UserView, Listen) ->
	"use strict"

	sanitize = (param) ->
		if /^\//.test param
			return param.substr 1
		return param

	# Defining the application router, you can attach sub routers here.
	Router = Backbone.Router.extend
		routes:
			'': 'index'
			'search': 'search'
			'search(/:what(/:where))': 'search'
			'list/:id': 'list'
			'user': 'user'
			'user/:name': 'user'
			'favorites': 'favorites'
			'login': 'login'
			'logout': 'logout'
			'profile': 'user'

		initialize: ->
			Parakeep.useLayout 'layouts/index'
			Parakeep.layout.setView('#navbar',
				@navbar = new NavbarView()).render()
			Parakeep.layout.setView('#menu',
				@menu = new MenuView()).render()

		reset: ->
			@menu.hideMenu().render()
			@navbar.setTitle()
			$('#searchbtn').removeClass('active')
			Parakeep.layout.removeView('#search')
			Parakeep.layout.removeView('#contents')

		index: ->
			@reset()
			Parakeep.layout.setView('#contents', new IndexView()).render()

		search: (what, where) ->
			@reset()
			list = new Listen.ItemCollection()
			$('#searchbtn').addClass('active')
			Parakeep.layout.setView('#search', 
				new SearchView
					list: list
					what: sanitize what
					where: sanitize where
				).render()
			Parakeep.layout.setView('#contents', new ListView(
				list: list,
				itemTemplate: 'items/minivenue'
			)).render()

		list: (listId, title) ->
			@reset()
			# lookup the requested list and then make a ListView for it
			list = new Listen.List
				id: listId
			list.fetch
				success: =>
					@navbar.setTitle(list.get('title'))
					Parakeep.layout.setView('#contents', 
						new ListView(model: list)).render()
				error: ->
					console.error arguments
					# if list lookup fails then redirect to index
					Parse.history.navigate '', true

		favorites: ->
			# load the current user's favorites list
			@list Parse.User.current().get('favorites').id

		login: ->
			@reset()
			Parakeep.layout.setView('#contents',
				new LoginView()).render()

		logout: ->
			Parse.User.logOut()
			@menu.render()
			window.history.back()

		# profile: ->
		# 	Parakeep.layout.setView('#profile', new ProfileView()).render()


		# TODO: implement authentication first
		user: (username) ->
			# display a User page if the username exists
			if username
				query = new Parse.Query(Parse.User)
				query.equalTo 'username', username
				query.first
					success: (user) ->
						Parakeep.layout.setView('#contents', new UserView(model: user)).render()
					error: (user, error) ->
						alert 'What the ish, this usar doesn\'t exist'
						# what happens here? null model?
			else
				Parakeep.layout.setView('#contents', new UserView(model: Parse.User.current())).render()

