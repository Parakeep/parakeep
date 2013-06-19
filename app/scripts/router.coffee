define ['app', 'views/navbar', 'views/search', 'views/index', 'views/list', 'models/listen'], 
(Parakeep, NavbarView, SearchView, IndexView, ListView, Listen) ->
	"use strict"
	
	# Defining the application router, you can attach sub routers here.
	Router = Backbone.Router.extend
		routes:
			'': 'index'
			'list/:id': 'list'
			'user': 'user'
			'user/:name': 'user'

		initialize: ->
			Parakeep.useLayout 'layouts/index'
			Parakeep.layout.setView('#navbar', 
				new NavbarView()).render()

		index: ->
			# create an IndexView with empty ListCollection, to be fetched in the view
			Parakeep.layout.setView('#contents', new IndexView
				model: new Listen.ListCollection()
			).render()

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

