App.LocationController = Ember.ObjectController.extend

  seminarSorting: ["startAt:desc"]
  sortedSeminars: Ember.computed.sort("seminars", 'seminarSorting')

  latestSeminars: (->
    @get("sortedSeminars").filter (seminar) =>
      @get("sortedSeminars").indexOf(seminar) < 10
  ).property("seminars")

  actions:
    destroy: (location) ->
      self = @
      if location.get("destroyable")
        bootbox.confirm "Are you sure to destroy location “#{location.get("name")}”?", (result) ->
          if result
            location.deleteRecord()
            location.save().then(
              (->
                self.transitionToRoute 'locations'
                Flash.NM.push 'Location successfully destroyed', "success"
              ),
              ((error)->
                location.rollback()
                Flash.NM.push "An error occured: #{error}", "danger"
              )
            )
      else
        Flash.NM.push "You can't destroy this location", "danger"

    close: ->
      this.transitionToRoute('locations')
