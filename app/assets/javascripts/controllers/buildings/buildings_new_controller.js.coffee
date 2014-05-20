App.BuildingsNewController = Ember.ObjectController.extend App.ValidationErrorsMixin,

  pageTitle: "New building"

  actions:
    create: (building) ->
      if App.Session.authUser == undefined || App.Session.authUser.get("can_create_buildings") == false
        building.rollback()
        Flash.NM.push 'You are not authorized to access this page', "danger"
      else
        self = @
        building.save().then(
          (->
            Flash.NM.push 'Building successfully created', "success"
            # self.transitionToRoute 'buildings'
            self.send "closeModal"
          ),
          ((error) ->
            self.setValidationErrors error.message
          )
        )
