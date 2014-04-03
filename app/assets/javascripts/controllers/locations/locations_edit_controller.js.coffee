App.LocationsEditController = Ember.ObjectController.extend App.ValidationErrorsMixin,

  pageTitle: "Edit location"

  actions:
    update: (location) ->
      self = @
      location.save().then(
        (->
          Flash.NM.push 'Location successfully updated', "success"
          # self.transitionToRoute 'locations.location', location
          history.go -1
        ),
        ((error) ->
          self.setValidationErrors error.message
        )
      )

    cancel: (location) ->
      location.rollback()
      history.go -1

