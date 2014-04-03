App.LocationController = Ember.ObjectController.extend
  actions:
    destroy: (location) ->
      self = @
      if location.get("destroyable")
        if confirm "Are you sure to destroy location “#{location.name}”?"
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
