App.SeminarsNewController = Ember.ObjectController.extend App.ValidationErrorsMixin,

  needs: ["categories", "hosts", "locations"]

  selectCategories: (->
    @get('controllers.categories')
  ).property('controllers.categories')

  sortedSelectHosts: (->
    @get('controllers.hosts')
  ).property('controllers.hosts')

  sortedSelectLocations: (->
    @get('controllers.locations')
  ).property('controllers.locations')

  actions:
    create: (seminar) ->
      if App.Session.authUser == undefined || App.Session.authUser.get("can_create_seminars") == false
        seminar.deleteRecord()
        Flash.NM.push 'You are not authorized to access this page', "danger"
      else
        self = @
        # debugger
        seminar.set "startAt", moment(@get('startAt')).toDate()
        seminar.set "endAt", moment(seminar.get("startAt")).add('hours', 1).toDate unless seminar.get("endAt")?
        seminar.save({associations: true}).then(
          (->
            Flash.NM.push 'Seminar successfully created', "success"
            self.transitionToRoute 'seminars.next'
          ),
          ((error) ->
            self.setValidationErrors error.message
          )
        )

    cancel: (seminar) ->
      seminar.deleteRecord() if seminar
      @transitionToRoute 'seminars.next'

    addHosting: (seminar) ->
      seminar.get('hostings').addObject @store.createRecord("hosting", {seminar: seminar})
    removeHosting: (hosting) ->
      zis = @
      if hosting.get('isNew')
        zis.content.get('hostings').removeObject(hosting)
      else
        bootbox.confirm "Are you sure to destroy remove this host?", (result) ->
          zis.content.get('hostings').removeObject(hosting) if result

    addCategorisation: (seminar) ->
      seminar.get('categorisations').addObject @store.createRecord("categorisation", {seminar: seminar})

    removeCategorisation: (categorisation) ->
      zis = @
      if categorisation.get('isNew')
        zis.content.get('categorisations').removeObject(categorisation)
      else
        bootbox.confirm "Are you sure you want to remove this host?", (result) ->
          zis.content.get('categorisations').removeObject(categorisation) if result
