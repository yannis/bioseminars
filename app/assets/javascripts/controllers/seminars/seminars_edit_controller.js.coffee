App.SeminarsEditController = Ember.ObjectController.extend App.ValidationErrorsMixin,
  actions:
    # update: (seminar) ->
    #   @get('store').commit()
    #   @transitionToRoute 'seminar', seminar
    # cancel: (seminar) ->
    #   seminar.transaction.rollback()
    #   @transitionToRoute 'seminar', seminar

    update: (seminar) ->
      self = @
      # debugger
      seminar.set "startAt", moment(seminar.get('startAt')).toDate()
      seminar.set "endAt", moment(seminar.get("startAt")).add('hours', 1).toDate unless seminar.get("endAt")?
      seminar.save().then(
        (->
          Flash.NM.push 'Seminar successfully updated', "success"
          # self.transitionToRoute 'seminars.seminar', seminar
          history.go -1
        ),
        ((error) ->
          self.setValidationErrors error.message
        )
      )

    cancel: (seminar) ->
      seminar.rollback()
      history.go -1
      # @transitionToRoute 'seminar', seminar


    addHosting: (seminar) ->
      seminar.get('hostings').addObject @store.createRecord("hosting", {seminar: seminar})
    removeHosting: (hosting) ->
      @get("model.hostings").removeObject(hosting)
      # zis = @
      # if hosting.get('isNew')
      #   zis.content.get('hostings').removeObject(hosting)
      # else
      #   bootbox.confirm "Are you sure you want to remove this host?", (result) ->
      #     zis.content.get('hostings').removeObject(hosting) if result

    addCategorisation: (seminar) ->
      # debugger
      seminar.get('categorisations').addObject @store.createRecord("categorisation", {seminar: seminar})
      # debugger

    removeCategorisation: (categorisation) ->
      # debugger
      @get("model.categorisations").removeObject(categorisation)
      # zis = @
      # if categorisation.get('isNew')
      #   zis.content.get('categorisations').removeObject(categorisation)
      # else
      #   bootbox.confirm "Are you sure you want to remove this host?", (result) ->
      #     zis.content.get('categorisations').removeObject(categorisation) if result
