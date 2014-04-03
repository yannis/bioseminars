App.BuildingsEditController = Ember.ObjectController.extend App.ValidationErrorsMixin,

  pageTitle: "Edit building"

  actions:
    update: (building) ->
      self = @
      building.save().then(
        (->
          Flash.NM.push 'Building successfully updated', "success"
          # self.transitionToRoute 'buildings.building', building
          history.go -1
        ),
        ((error) ->
          self.setValidationErrors error.message
        )
      )

    cancel: (building) ->
      building.rollback()
      history.go -1
      # @transitionToRoute 'building', building
