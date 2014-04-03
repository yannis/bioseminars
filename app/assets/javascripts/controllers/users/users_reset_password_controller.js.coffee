App.UsersResetPasswordController = Ember.Controller.extend

  # needs: ["session_new"]

  pageTitle: "Reset your password"

  # email: (->
  #   @get("controller.session_new.email")
  #   debugger
  # ).property("controller.session_new.email")

  actions:
    reset_password: ->
      self = @
      data = @getProperties('email')
      console.log "data", data
      if !Ember.isEmpty(data.email)
        postData =
          user:
            email: data.email
        $.post('/users/password', postData)
          .done (response, textStatus, jqXHR) ->
            Flash.NM.push "You will receive an email with instructions about how to reset your password in a few minutes.", "success"
            self.transitionToRoute 'session.new'
          .fail ->
            Flash.NM.push "Invalid email.", "danger"
      else
        Flash.NM.push "Email can't be blank", "danger"

    cancel: ->
      @transitionToRoute('index')
