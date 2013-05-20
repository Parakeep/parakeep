define ['models/listen'], (Listen) ->
	###
	Manages form to create a new Listen.List
	###
	class NewListView extends Parse.View
		template: 'new-list'

		events:
			'submit form': 'create'

		create: (evt) ->
			evt.preventDefault()

			name = @$('#name').val().trim()

			if name
				list = new Listen.List(title: name)
				list.save
					success: ->
						Parse.history.navigate 'list/' + list.id, true