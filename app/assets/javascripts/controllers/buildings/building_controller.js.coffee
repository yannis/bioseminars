App.BuildingController = Ember.ObjectController.extend
  actions:
    destroy: (building) ->
      self = @
      if building.get("destroyable")
        if confirm "Are you sure to destroy building “#{building.name}”?"
          building.deleteRecord()
          building.save().then(
            (->
              self.transitionToRoute 'buildings'
              Flash.NM.push 'Building successfully destroyed', "success"
            ),
            ((error)->
              building.rollback()
              Flash.NM.push "An error occured: #{error}", "danger"
            )
          )
      else
        Flash.NM.push "You can't destroy this building", "danger"

    close: ->
      this.transitionToRoute('buildings')
