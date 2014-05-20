App.HostsEditController = Ember.ObjectController.extend App.ValidationErrorsMixin,

  pageTitle: (->
    "Edit host “#{@get('model.name')}”"
  ).property("model.name")

  actions:
    update: (host) ->
      self = @
      host.save().then(
        (->
          Flash.NM.push 'Host successfully updated', "success"
          self.send('closeModal')
        ),
        ((error) ->
          self.setValidationErrors error
        )
      )
