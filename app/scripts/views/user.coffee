define ->
    class UserView extends Backbone.View
        template: 'user'

        serialize: ->
            console.log Parse.User.current()
            user: Parse.User.current().attributes
