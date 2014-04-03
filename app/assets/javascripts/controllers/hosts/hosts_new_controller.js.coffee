App.HostsNewController = Ember.ObjectController.extend App.ValidationErrorsMixin,
  pageTitle: "New host"
  actions:
    create: (host) ->
      if App.Session.authUser == undefined || App.Session.authUser.get("can_create_hosts") == false
        host.deleteRecord()
        Flash.NM.push 'You are not authorized to access this page', "danger"
      else
        self = @
        host.save().then(
          (->
            Flash.NM.push 'Host successfully created', "success"
            self.transitionToRoute 'hosts'
          ),
          ((error) ->
            self.setValidationErrors error.message
          )
        )

    cancel: (host) ->
      host.deleteRecord() if host
      @transitionToRoute 'hosts'
