App.BuildingsNewController = Ember.ObjectController.extend App.ValidationErrorsMixin,

  pageTitle: "New building"

  actions:
    create: (building) ->
      if @session? && @session.get("user.can_create_buildings") == false
        building.rollback()
        Flash.NM.push 'You are not authorized to access this page', "info"
      else
        self = @
        building.save().then(
          (->
            Flash.NM.push 'Building successfully created', "success"
            self.send "closeModal"
          ),
          ((error) ->
            self.setValidationErrors error
          )
        )
