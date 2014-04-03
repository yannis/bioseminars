App.UsersNewPasswordController = Ember.Controller.extend

  pageTitle: "Change your password"

  actions:
    update_password: ->
      # debugger
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
      console.log "putData", putData
      $.ajax(
        type: "PUT"
        url: "/users/password"
        data: putData
        dataType: "json"
      )
      .done (response, textStatus, jqXHR) ->
        console.log "response", response
        console.log "textStatus", textStatus
        console.log "jqXHR", jqXHR
        Flash.NM.push "Your password was changed successfully.", "success"
        self.transitionToRoute 'session.new'
      .fail (response, textStatus, jqXHR) ->
        console.log "response", response
        console.log "textStatus", textStatus
        console.log "jqXHR", jqXHR
        Flash.NM.push Em.inspect(JSON.parse(response['responseText'])['errors']), "danger"
        # Flash.NM.push "You can't access this page without coming from a password reset email. If you do come from a password reset email, please make sure you used the full URL provided.", "danger"

    cancel: ->
      @transitionToRoute('index')
