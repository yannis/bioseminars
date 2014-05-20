App.BuildingController = Ember.ObjectController.extend
  actions:
    destroy: (building) ->
      self = @
      if building.get("destroyable")
        bootbox.confirm "Are you sure to destroy building “#{building.get("name")}”?", (result) ->
          if result
            building.deleteRecord()
            building.save().then(
              (->
                self.transitionToRoute 'buildings'
                Flash.NM.push 'Building successfully destroyed', "success"
              ),
              ((error)->
                building.rollback()
                Flash.NM.push "An error occured: #{error.message}", "danger"
              )
            )
      else
        Flash.NM.push "You can't destroy this building", "danger"

    close: ->
      this.transitionToRoute('buildings')
