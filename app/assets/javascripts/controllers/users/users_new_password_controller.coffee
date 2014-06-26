App.UsersNewPasswordController = Ember.Controller.extend App.ValidationErrorsMixin,

  pageTitle: "Change your password"

  actions:
    update_password: ->
      self = @
      data = @getProperties('password', 'password_confirmation')
      if Ember.isEmpty(data.password) && Ember.isEmpty(data.password_confirmation)
        self.set 'validationErrors', ["Your password can't be blank"]
        return false
      if data.password != data.password_confirmation
        self.set 'validationErrors', ["Your password doesn't match the confirmation"]
        return false
      putData =
        user:
          password: data.password
          password_confirmation: data.password_confirmation
          reset_password_token: self.get("model")
      $.ajax(
        type: "PUT"
        url: "/users/password"
        data: putData
        dataType: "json"
      )
      .done (response, textStatus, jqXHR) ->
        Flash.NM.push "Your password was changed successfully.", "success"
        self.transitionToRoute 'login'
      .fail (response, textStatus, jqXHR) ->
        self.setValidationErrors JSON.parse(response['responseText'])

    cancel: ->
      @transitionToRoute('index')
