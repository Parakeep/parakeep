# all the top-level dependencies go here. simply requiring 'app' will give you all these libraries.
define ["jquery", "lodash", "parse", "plugins/backbone.layoutmanager"], ($, _, Parse) ->
  "use strict"
  
  # Provide a global location to place configuration settings and module creation.
  app = root: "/"
  
  # Localize or create a new JavaScript Template object.
  JST = window.JST = window.JST or {}
  
  # Configure LayoutManager with Backbone Boilerplate defaults.
  Parse.LayoutManager.configure
    manage: true
    
    paths:
      layout: 'layouts/'

    fetch: (path) ->
      # Handlebars pre-compiled templates make this about as easy as possible.
      # either the template exists and is ready to rock, or it doesn't and never will.
      console.error "unknown template '#{path}'" unless JST[path]
      JST[path]
  
  # Mix Backbone.Events, modules, and layout management into the app object.
  _.extend app, Parse.Events,
    
    # Create a custom object with a nested Views object.
    module: (additionalProps) ->
      _.extend Views: {}, additionalProps
    
    # Helper for using layouts.
    useLayout: (name) ->
      # If already using this Layout, then don't re-inject into the DOM.
      return @layout  if @layout and @layout.options.template is name
      # If a layout already exists, remove it from the DOM.
      @layout.remove()  if @layout
      # Create a new Layout.
      layout = new Parse.Layout
        template: name
        className: "layout " + name
        id: "layout"
      # Insert into the DOM.
      $("#main").empty().append layout.el
      # Render the layout.
      layout.render()
      # Cache the refererence.
      @layout = layout
      # Return the reference, for chainability.
      layout

