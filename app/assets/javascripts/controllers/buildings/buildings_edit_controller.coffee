App.BuildingsEditController = Ember.ObjectController.extend App.ValidationErrorsMixin,

  pageTitle: (->
    "Edit building “#{@get('model.name')}”"
  ).property("model.name")

  actions:
    update: (building) ->
      self = @
      building.save().then(
        (->
          Flash.NM.push 'Building successfully updated', "success"
          self.send('closeModal')
        ),
        ((error) ->
          self.setValidationErrors error
        )
      )
