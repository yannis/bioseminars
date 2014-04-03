App.UsersNewController = Ember.ObjectController.extend App.ValidationErrorsMixin,
  pageTitle: "New user"
  actions:
    create: (user) ->
      self = @
      user.save().then(
        (->
          Flash.NM.push 'User successfully created', "success"
          self.transitionToRoute 'users.user', user
        ),
        ((error) ->
          self.setValidationErrors error.message
        )
      )
    cancel: (user) ->
      user.rollback() if user
      @transitionToRoute 'users'
