_ = require('underscore');

var FOURSQUARE_OPTIONS = {
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

// creates quick name for SEO list URLs
// #/list/objectId/human-readable-list-name
Parse.Cloud.beforeSave("List", function(request, response) {
	var title = request.object.get("title");
	// lowercase + remove non-word characters + trim whitespace + replace spaces with dashes
	var fixed = title.toLowerCase().replace(/\W/g, ' ').trim().replace(/\s+/g, '-');
	request.object.set("quickName", fixed);

	if (request.object.get('title').length > 1)
		response.success();
	// else if (!request.object.get('user'))
	// 	response.error('List must have User')
	else {
		response.error('List must have title')
	}
});

Parse.Cloud.beforeSave("Item", function(request, response) {
	if (!request.object.get('data'))
		response.error('Item must have data object')
	else if (!request.object.get('source'))
		response.error('Item must have source')
	else if (!request.object.get('list'))
		response.error('Item must belong to List')
	// else if (!request.get('user'))
	// 	response.error('Item must have User')
	else
		response.success()
});