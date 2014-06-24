App.HostController = Ember.ObjectController.extend

  seminarSorting: ["startAt:desc"]
  sortedSeminars: Ember.computed.sort("seminars", 'seminarSorting')

  latestSeminars: (->
    @get("sortedSeminars").filter (seminar) =>
      @get("sortedSeminars").indexOf(seminar) < 10
  ).property("seminars")

  actions:
    destroy: (host) ->
      self = @
      if host.get("destroyable")
        bootbox.confirm "Are you sure to destroy host “#{host.get("name")}”?", (result) ->
          if result
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
