App.UsersEditController = Ember.ObjectController.extend

  pageTitle: "Edit user"

  actions:
    update: (user) ->
      self = @
      user.save().then(
        (->
          Flash.NM.push 'User successfully updated', "success"
          history.go -1
        ),
        ((error) ->
          if error.responseText.length
            Flash.NM.push JSON.parse(error.responseText)["message"], "danger"
          else
            self.setValidationErrors error.message
        )
      )

    cancel: (user) ->
      user.rollback()
      history.go -1

