App.HostController = Ember.ObjectController.extend
  actions:
    destroy: (host) ->
      self = @
      if host.get("destroyable")
        if confirm "Are you sure to destroy host “#{host.name}”?"
          host.deleteRecord()
          host.save().then(
            (->
              self.transitionToRoute 'hosts'
              Flash.NM.push 'Host successfully destroyed', "success"
            ),
            ((error)->
              host.rollback()
              Flash.NM.push "An error occured: #{error}", "danger"
            )
          )
      else
        Flash.NM.push "You can't destroy this host", "danger"

    close: ->
      this.transitionToRoute('hosts')