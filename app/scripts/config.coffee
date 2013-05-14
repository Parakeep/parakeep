# Set the require.js configuration for your application.
require.config
  # Initialize the application with the main application file.
  deps: ["main"]

  paths:
    # JavaScript folders.
    libs: "../scripts/libs"
    plugins: "../scripts/plugins"
    # Libraries.
    jquery: "../scripts/libs/jquery"
    lodash: "../scripts/libs/lodash"
    backbone: "../scripts/libs/backbone"
    # PARSE
    parse: "../components/parse-js-sdk/lib/parse"

  shim:
    # Parse library depends on lodash and jQuery, just like Backbone.
    parse:
      deps: ["lodash", "jquery"]
      exports: "Parse"
    
    # Backbone.LayoutManager depends on Parse now!
    "plugins/backbone.layoutmanager": ["parse"]

