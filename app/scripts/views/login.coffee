define ['models/listen'], (Listen) ->
	class LoginView extends Backbone.View
		template: 'login'

		events:
			'click button': 'fbLogin'

		fbLogin: (e) ->
			Parse.FacebookUtils.logIn null,
				success: (user) ->
					unless user.get('favorites')
						console.log 'creating favorites list...'
						# favorites list, standard properties for all
						favorites = new Listen.List
							user: user
							title: 'Your Favorites'
							tagline: 'All the things you love'
							quickName: 'favorites'
							private: true
						# save it and store reference in the user object
						favorites.save null,
							success: (list) ->
								user.save { favorites: list }
								console.log 'favorites list:', list
							error: (list, error) ->
								console.error 'favorites error:', error

					Backbone.history.navigate '/', true
				error: (user, error) ->
					alert 'user cancelled the F out of this B'
