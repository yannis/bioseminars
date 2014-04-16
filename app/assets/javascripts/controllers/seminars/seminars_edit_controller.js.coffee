App.SeminarsEditController = Ember.ObjectController.extend App.ValidationErrorsMixin,

  selectCategoriesSorting: ['position']
  sortedSelectCategories: Ember.computed.sort('selectCategories', 'selectCategoriesSorting')

  selectHostsSorting: ['name']
  sortedSelectHosts: Ember.computed.sort('selectHosts', 'selectHostsSorting')

  selectLocationsSorting: ['name']
  sortedSelectLocations: Ember.computed.sort('selectLocations', 'selectLocationsSorting')

  actions:

    update: (seminar) ->
      self = @
      seminar.set "startAt", moment(seminar.get('startAt')).toDate()
      seminar.set "endAt", moment(seminar.get("startAt")).add('hours', 1).toDate unless seminar.get("endAt")?
      seminar.save().then(
        (->
          Flash.NM.push 'Seminar successfully updated', "success"
          history.go -1
        ),
        ((error) ->
          self.setValidationErrors error.message
        )
      )

    cancel: (seminar) ->
      seminar.rollback()
      history.go -1

    addHosting: (seminar) ->
      seminar.get('hostings').addObject @store.createRecord("hosting", {seminar: seminar})
    removeHosting: (hosting) ->
      @get("model.hostings").removeObject(hosting)

    addCategorisation: (seminar) ->
      seminar.get('categorisations').addObject @store.createRecord("categorisation", {seminar: seminar})

    removeCategorisation: (categorisation) ->
      @get("model.categorisations").removeObject(categorisation)
