define ['app', 'views/menu', 'views/navbar', 'views/search', 'views/index', 'views/list', 'views/login', 'models/listen'], 
(Parakeep, MenuView, NavbarView, SearchView, IndexView, ListView, LoginView, Listen) ->
	"use strict"
	
	# Defining the application router, you can attach sub routers here.
	Router = Backbone.Router.extend
		routes:
			'': 'index'
			'search': 'search'
			'list/:id': 'list'
			'user': 'user'
			'user/:name': 'user'
			'login': 'login'
			'logout': 'logout'

		initialize: ->
			Parakeep.useLayout 'layouts/index'
			Parakeep.layout.setView('#navbar', 
				@navbar = new NavbarView()).render()
			Parakeep.layout.setView('#menu',
				@menu = new MenuView()).render()

		index: ->
			@menu.render()
			# create an IndexView with empty ListCollection, to be fetched in the view
			Parakeep.layout.setView('#contents', new IndexView
				model: new Listen.ListCollection()
			).render()

		search: ->
			list = new Listen.ItemCollection()
			$('#searchbtn').addClass('active')
			Parakeep.layout.setView('#search', 
				new SearchView(list: list)).render()
			Parakeep.layout.setView('#contents', new ListView(
				list: list, 
				itemTemplate: 'items/minivenue'
			)).render()

		list: (listId, title) ->
			# lookup the requested list and then make a ListView for it
			list = new Listen.List
				id: listId
			list.fetch
				success: ->
					Parakeep.layout.setView('#contents', 
						new ListView(model: list)).render()
				error: ->
					# if list lookup fails then redirect to index
					Parse.history.navigate '', true

		login: ->
			Parakeep.layout.setView('#contents', 
				new LoginView()).render()

		logout: ->
			Parse.User.logOut()
			@menu.render()
			window.history.back()

		# TODO: implement authentication first
		user: (username) ->
			# display a User page if the username exists
			# if username
			# 	query = new Parse.Query(Parse.User)
			# 	query.equalTo 'username', username
			# 	query.first
			# 	success: (user) ->
			# 	Parakeep.layout.setView('#contents', new UserView(model: user)).render()
			# 	error: (user, error) ->
			# 	# what happens here? null model?
			# else
			# 	Parakeep.layout.setView('#contents', new UserView(model: Parse.User.current())).render()

