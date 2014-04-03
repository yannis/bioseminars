App.SessionDestroyController = Ember.Controller.extend
  logout: ->
    self = this
    $.ajax(
      url:  '/session'
      type: 'DELETE'
    ).always (response) ->
      console.log "response", response
      if response['status'] && response['status'] > 400
        text = JSON.parse(response['responseText'])['errors']
        if text.length
          Flash.NM.push text, "danger"
        else
          Flash.NM.push 'Unable to sign out', "danger"
        window.history.go(-1)
      else
        App.Session.setProperties
          authToken: null
        self.transitionToRoute "session.new"
