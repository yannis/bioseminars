App.LocationsNewController = Ember.ObjectController.extend App.ValidationErrorsMixin,

  needs: ['buildings']

  pageTitle: "New location"

  actions:
    create: (location) ->
      if @session? && @session.get("user.can_create_locations") == false
        location.rollback()
        Flash.NM.push 'You are not authorized to access this page', "info"
      else
        self = @
        location.save().then(
          (->
            Flash.NM.push 'Location successfully created', "success"
            self.send "closeModal"
          ),
          ((error) ->
            self.setValidationErrors error
          )
        )
