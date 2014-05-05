App.UsersNewPasswordController = Ember.Controller.extend

  pageTitle: "Change your password"

  actions:
    update_password: ->
      self = @
      data = @getProperties('password', 'password_confirmation')
      if Ember.isEmpty(data.password) && Ember.isEmpty(data.password_confirmation)
        Flash.NM.push "Your password can't be blank", "danger"
        return false
      if data.password != data.password_confirmation
        Flash.NM.push "Your password doesn't match the confirmation", "danger"
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
        self.transitionToRoute 'session.new'
      .fail (response, textStatus, jqXHR) ->
        Flash.NM.push Em.inspect(JSON.parse(response['responseText'])['message']), "danger"

    cancel: ->
      @transitionToRoute('index')
