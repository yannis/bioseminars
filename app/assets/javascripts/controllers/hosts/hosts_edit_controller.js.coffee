App.HostsEditController = Ember.ObjectController.extend

  pageTitle: "Edit host"

  actions:
    update: (host) ->
      self = @
      host.save().then(
        (->
          Flash.NM.push 'Host successfully updated', "success"
          history.go -1
        ),
        ((error) ->
          console.log "error", JSON.parse(error.responseText)
          if error.responseText.length
            Flash.NM.push JSON.parse(error.responseText)["message"], "danger"
          else
            self.setValidationErrors error.message
        )
      )

    cancel: (host) ->
      host.rollback()
      history.go -1

