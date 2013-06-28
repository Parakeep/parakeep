define ['bootstrap/bootstrap-modal'], () ->
	class MessageView extends Backbone.View
		template: 'message'
		className: 'modal'

		initialize: ->

		serialize: -> @options

		# Launches this ModalView as a Bootstrap modal dialog using the jQuery plugin.
		# Returns a promise that resolves when modal is closed. 
		# The promise is never rejected but it's safer to use always() instead of done()
		modal: (options) ->
			# if we don't have a reference to it then the modal hasn't been rendered
			@render() unless @_modal	

			@_modal = @$el.modal(options)	
			deferred = new $.Deferred()
			# resolve the promise on modal hide
			@_modal.on 'hide', -> deferred.resolve()
			return deferred