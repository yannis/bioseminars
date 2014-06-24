App.LocationsEditController = Ember.ObjectController.extend App.ValidationErrorsMixin,

  needs: ['buildings']

  pageTitle: (->
    "Edit location “#{@get('model.name')}”"
  ).property("model.name")

  actions:
    update: (location) ->
      self = @
      location.save().then(
        (->
          Flash.NM.push 'Location successfully updated', "success"
          self.send('closeModal')
        ),
        ((error) ->
          self.setValidationErrors error
        )
      )
