require([
    // Application.
    'app',
    'backbone',
    'jquery',
    'parse',

    // Main Router.
    'router'
],

function (app, Backbone, $, parse, Router) {
    'use strict';
    // Define your master router on the application namespace and trigger all
    // navigation from this instance.
    app.router = new Router();

    // Trigger the initial route and enable HTML5 History API support, set the
    // root folder to '/' by default.  Change in app.js.
    Backbone.history.start({ pushState: true, root: app.root });

    // All navigation that is relative should be passed through the navigate
    // method, to be processed by the router. If the link has a `data-bypass`
    // attribute, bypass the delegation completely.
    $(document).on('click', 'a:not([data-bypass])', function (evt) {
        // Get the absolute anchor href.
        var href = $(this).attr('href');

        // If the href exists and is a hash route, run it through Backbone.
        if (href && href.indexOf('#') === 0) {
            // Stop the default event to ensure the link will not cause a page
            // refresh.
            evt.preventDefault();

            // `Backbone.history.navigate` is sufficient for all Routers and will
            // trigger the correct events. The Router's internal `navigate` method
            // calls this anyways.  The fragment is sliced from the root.
            Backbone.history.navigate(href, true);
        }
    });

    //GO GO GADGET PARSE
    Parse.initialize("GUyWWlIBRFetye705B98iJKYVHJN7ECrR6UJc7h6", "sngjSxV0QF9Tt2lndLVtsNobk332VAAVVu3LENNW");

    var TestObject = Parse.Object.extend("TestObject");
    var testObject = new TestObject();
    testObject.save({foo: "bar"}, {
        success: function(object) {
        alert("yay! it worked");
        }
    });



});
