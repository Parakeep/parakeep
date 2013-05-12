
Parse.Cloud.define("venueSearch", function(request, response) {
	// Foursquare API client ID and secret
	client = "POEOWI3KJ50IOFSY3404RKLQEBEG2TF4G4WOKXJGPRCJGKIK"
	secret = "OEC3JBPOEL22M0KTZLCJ3IBM2AL5BZQUPCDLDUJGYZC3I2J4"

	Parse.Cloud.httpRequest({
		url: 'https://api.foursquare.com/v2/venues/search',
		params: {
			query: request.params.query,
			near: request.params.near,
			client_id: client,
			client_secret: secret
		},
		success: function(httpResponse) {
			response.success(httpResponse.text);
		},
		error: function(httpResponse) {
			response.error('Request failed with response code ' + httpResponse.status);
		}
	});
});