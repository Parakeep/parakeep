require ["app", "backbone", "jquery", "parse", "router"], (app, Backbone, $, parse, Router) ->
  "use strict"
  # Define your master router on the application namespace and trigger all
  # navigation from this instance.
  app.router = new Router()

  # Trigger the initial route and enable HTML5 History API support, set the
  # root folder to '/' by default.  Change in app.js.
  Backbone.history.start
    # pushState: true
    root: app.root

  # All navigation that is relative should be passed through the navigate
  # method, to be processed by the router. If the link has a `data-bypass`
  # attribute, bypass the delegation completely.
  $(document).on "click", "a:not([data-bypass])", (evt) ->
    # Get the absolute anchor href.
    href = $(this).attr("href")
    # If the href exists and is a hash route, run it through Backbone.
    if href and href.indexOf("#") is 0
      # Stop the default event to ensure the link will not cause a page refresh.
      evt.preventDefault()
      # `Backbone.history.navigate` is sufficient for all Routers and will
      # trigger the correct events. The Router's internal `navigate` method
      # calls this anyways.  The fragment is sliced from the root.
      Backbone.history.navigate href, true

  #GO GO GADGET PARSE
  Parse.initialize "ratnJMKXEJoVfL7OJoFfdeNOeepJd0oQ6Wz0MsF7", "rXWu04kUDnOpQT1vFxH5MeveLsGOd3sqysVOiTMa"

  $('header').html(JST.search())

  $('#search').on 'submit', (evt) ->
    evt.preventDefault()
    # show loading spinner
    $('#loading').removeClass 'hide'
    # fire off Parse Cloud request
    Parse.Cloud.run 'venueSearch', { query: $('#query').val(), near: $('#near').val() },
      success: (response) ->
        $('#loading').addClass 'hide'
        list = $('#list').html('')
        items = JSON.parse(response).response.groups[0].items
        if items.length
          list.append(JST.business item) for item in items
        else
          list.html JST.error 
            message: "No results found"
            icon: 'remove'
      error: (error) ->
        $('#loading').addClass 'hide'
        console.error error
        $('#list').html JST.error
          message: error.message
          icon: 'remove'
