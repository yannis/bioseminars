App.SessionNewController = Ember.Controller.extend

  actions:
    login: ->
      self = @
      data = @getProperties('email', 'password')
      if !Ember.isEmpty(data.email) && !Ember.isEmpty(data.password)
        postData =
          session:
            email: data.email
            password: data.password
        $.post('/session', postData)
          .done (response, textStatus, jqXHR) ->
            if response.session && response.session.authentication_token
              Flash.NM.push 'Successfully signed in', 'success'
              sessionData = (response.session || {})

              App.Session.setProperties
                authToken: sessionData.authentication_token
                authUserId: sessionData.user_id
                authUser: self.store.find "user", sessionData.user_id
                # authUserEmail: sessionData.email
              attemptedTransition = App.Session.get('attemptedTransition')
              if (attemptedTransition)
                attemptedTransition.retry()
                App.Session.set('attemptedTransition', null)
              else
                self.transitionToRoute 'index'

            else
              Flash.NM.push 'Unable to log in', 'danger'
          .fail (response, textStatus, jqXHR) ->
            Flash.NM.push JSON.parse(response['responseText'])['message'], "danger"

    cancel: ->
      @transitionToRoute('index')
