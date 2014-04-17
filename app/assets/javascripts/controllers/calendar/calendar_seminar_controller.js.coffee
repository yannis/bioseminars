App.CalendarSeminarController = Em.ObjectController.extend
  actions:
    close: ->
      this.transitionToRoute('calendar')
    destroy: (seminar) ->
      self = @
      if seminar.get("destroyable")
        bootbox.confirm "Are you sure you want to destroy this seminar?", (result) ->
          if result
            seminar.deleteRecord()
            seminar.save().then(
              (->
                self.transitionToRoute "seminars"
                Flash.NM.push 'Seminar successfully destroyed', "success"
              ),
              ((error)->
                seminar.rollback()
                Flash.NM.push "An error occured: #{error}", "danger"
              )
            )
      else
        Flash.NM.push "You can't destroy this seminar", "danger"

