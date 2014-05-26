App.UsersNewController = Ember.ObjectController.extend App.ValidationErrorsMixin,
  pageTitle: "New user"

  actions:
    create: (user) ->
      if @session? && @session.get("user.can_create_users") == false
        user.rollback()
        Flash.NM.push 'You are not authorized to access this page', "info"
      else
        self = @
        user.save().then(
          (->
            Flash.NM.push 'User successfully created', "success"
            self.send "closeModal"
          ),
          ((error) ->
            self.setValidationErrors error
          )
        )
