_ = require('underscore');

FOURSQUARE_OPTIONS = {
	// Foursquare API client ID and secret and version for userless requests
	client_id: "POEOWI3KJ50IOFSY3404RKLQEBEG2TF4G4WOKXJGPRCJGKIK",
	client_secret: "OEC3JBPOEL22M0KTZLCJ3IBM2AL5BZQUPCDLDUJGYZC3I2J4",
	v: 20130510
};

Parse.Cloud.define("venueSearch", function(request, response) {
	Parse.Cloud.httpRequest({
		url: 'https://api.foursquare.com/v2/venues/search',
		// pass along params with foursquare options.
		// client side chooses to send query and [near | ll]
		params: _.extend(request.params, FOURSQUARE_OPTIONS),
		success: function(httpResponse) {
			response.success(httpResponse.text);
		},
		error: function(httpResponse) {
			response.error('Request failed with response code ' + httpResponse.status);
		}
	});
});

Parse.Cloud.define("venueCompletion", function(request, response) {
	Parse.Cloud.httpRequest({
		url: 'https://api.foursquare.com/v2/venues/suggestcompletion',
		params: _.extend(request.params, FOURSQUARE_OPTIONS),
		success: function(httpResponse) {
			response.success(httpResponse.text);
		},
		error: function(httpResponse) {
			response.error('Request failed with response code ' + httpResponse.status);
		}
	});
});