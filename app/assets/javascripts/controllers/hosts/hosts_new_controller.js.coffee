App.HostsNewController = Ember.ObjectController.extend App.ValidationErrorsMixin,
  pageTitle: "New host"
  actions:
    create: (host) ->
      if @session? && @session.get("user.can_create_hosts") == false
        host.rollback()
        Flash.NM.push 'You are not authorized to access this page', "info"
      else
        self = @
        host.save().then(
          (->
            Flash.NM.push 'Host successfully created', "success"
            self.send "closeModal"
          ),
          ((error) ->
            self.setValidationErrors error
          )
        )
