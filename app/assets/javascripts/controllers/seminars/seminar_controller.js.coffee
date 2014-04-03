App.SeminarController = Ember.ObjectController.extend
  actions:
    destroy: (seminar) ->
      # debugger
      # if confirm "Are you sure to destroy seminar “#{seminar.name}”?"
      #   seminar.deleteRecord()
      #   @get('store').commit()
      #   alert "seminar destroyed?", seminar.isDestroyed
      #   @transitionToRoute 'seminars'

      self = @
      if seminar.get("destroyable")
        if confirm "Are you sure to destroy seminar “#{seminar.get("title")}”?"
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
    close: ->
      window.history.go(-1)
      # this.transitionToRoute('seminars')
