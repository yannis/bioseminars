App.UsersEditController = Ember.ObjectController.extend

  pageTitle: (->
    "Edit user “#{@get('model.name')}”"
  ).property("model.name")

  actions:
    update: (user) ->
      self = @
      user.save().then(
        (->
          Flash.NM.push 'User successfully updated', "success"
          self.send('closeModal')
        ),
        ((error) ->
          if error.responseText.length
            Flash.NM.push JSON.parse(error.responseText)["errors"], "danger"
          else
            self.setValidationErrors error
        )
      )
