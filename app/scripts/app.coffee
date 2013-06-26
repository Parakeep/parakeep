# all the top-level dependencies go here. simply requiring 'app' will give you all these libraries.
define ->
  "use strict"

  # Provide a global location to place configuration settings and module creation.
  app = root: "/"

  Handlebars.registerHelper 'first', (context, options) -> 
    if context.length then options.fn(context[0])

  Handlebars.registerHelper 'ifLoggedIn', (context, options) ->
    if Parse.User.current() then options.fn(context) else options.inverse(context)
  
  # Localize or create a new JavaScript Template object.
  JST = window.JST = window.JST or {}

  # removes the given class from all elements (optionally within scope selector)
  # and applies it to this element. useful for singleton class, such as .active
  $.fn.takeClass = (targetClass, scope='') ->
    $(scope + " ." + targetClass).removeClass targetClass
    @addClass targetClass
  
  # Configure LayoutManager with Backbone Boilerplate defaults.
  Backbone.Layout.configure
    manage: true

    fetch: (path) ->
      # Handlebars pre-compiled templates make this about as easy as possible.
      # either the template exists and is ready to rock, or it doesn't and never will.
      console.error "unknown template '#{path}'" unless JST[path]
      JST[path]
  
  # Mix Backbone.Events, modules, and layout management into the app object.
  _.extend app, Backbone.Events,
    
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
      layout = new Backbone.Layout
        template: name
        className: "layout menu-container " + name
        id: "layout"
      # Insert into the DOM.
      $("#main").empty().append layout.el
      # Render the layout.
      layout.render()
      # Cache the refererence.
      @layout = layout
      # Return the reference, for chainability.
      layout

