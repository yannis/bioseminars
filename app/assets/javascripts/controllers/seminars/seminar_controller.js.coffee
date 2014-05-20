App.SeminarController = Ember.ObjectController.extend
  actions:
    destroy: (seminar) ->
      self = @
      if seminar.get("destroyable")
        bootbox.confirm "Are you sure you want to destroy this seminar?", (result) ->
          if result
            seminar.deleteRecord()
            # $("#calendar").fullCalendar('removeEvents', seminar.get('id'))
            seminar.save().then(
              ((seminar)->
                self.transitionTo "/"
                Flash.NM.push 'Seminar successfully destroyed', "success"
              ),
              ((error)->
                seminar.rollback()
                Flash.NM.push "An error occured: #{error}", "danger"
              )
            )
      else
        Flash.NM.push "You can't destroy this seminar", "danger"
    close: ->
      window.history.go(-1)
      # this.transitionToRoute('seminars')
