define ->
	class LoginView extends Backbone.View
		template: 'login'

		events:
			'click button': 'fbLogin'

		initialize: ->

		beforeRender: ->

		fbLogin: (e) ->
			Parse.FacebookUtils.logIn null,
				success: (user) ->
					if user.existed()
						alert 'user logged in through FB!'
					else
						# TODO: create favorites list
						alert 'user signed up and logged in through FaaaaaceBoooooook!'
					Backbone.history.navigate '/', true
				error: (user, error) ->
					alert 'user cancelled the F out of this B'
