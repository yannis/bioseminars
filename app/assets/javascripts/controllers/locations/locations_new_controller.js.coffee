App.LocationsNewController = Ember.ObjectController.extend App.ValidationErrorsMixin,
  pageTitle: "Create a new location"

  actions:
    create: (location) ->
      if App.Session.authUser == undefined || App.Session.authUser.get("can_create_locations") == false
        location.deleteRecord()
        Flash.NM.push 'You are not authorized to access this page', "danger"
      else
        self = @
        location.save().then(
          (->
            Flash.NM.push 'Location successfully created', "success"
            self.transitionToRoute 'locations'
          ),
          ((error) ->
            self.setValidationErrors error.message
          )
        )

    cancel: (location) ->
      location.deleteRecord() if location
      @transitionToRoute 'locations'
