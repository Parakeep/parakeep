define ["backbone"], (Backbone) ->
  "use strict"
  
  # Defining the application router, you can attach sub routers here.
  Router = Backbone.Router.extend
    routes:
      "": "index"

    index: ->
