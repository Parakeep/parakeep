# Set the require.js configuration for your application.
require.config
  # Initialize the application with the main application file.
  deps: ["main"]

  paths:
    # JavaScript folders.
    libs: "../scripts/libs"
    plugins: "../scripts/plugins"
    # Libraries
    bootstrap: "../components/bootstrap-sass/js"
    parse: "../components/parse-js-sdk/lib/parse"

  shim:
    parse:
      exports: "Parse"
    
    # Backbone.LayoutManager depends on Parse now!
    "plugins/backbone.layoutmanager": ["parse"]

