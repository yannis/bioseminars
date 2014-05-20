App.HostsNewController = Ember.ObjectController.extend App.ValidationErrorsMixin,
  pageTitle: "New host"
  actions:
    create: (host) ->
      if App.Session.authUser == undefined || App.Session.authUser.get("can_create_hosts") == false
        host.rollback()
        Flash.NM.push 'You are not authorized to access this page', "danger"
      else
        self = @
        host.save().then(
          (->
            Flash.NM.push 'Host successfully created', "success"
            self.send "closeModal"
          ),
          ((error) ->
            self.setValidationErrors error.message
          )
        )
