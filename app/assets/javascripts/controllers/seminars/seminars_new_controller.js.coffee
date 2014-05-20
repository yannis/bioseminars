App.SeminarsNewController = Ember.ObjectController.extend App.ValidationErrorsMixin,

  pageTitle: "Create a seminar"

  needs: ["categories", "hosts", "locations"]

  limitedCategories: (->
    cats = @get('controllers.categories')
    activeCats = cats.filter (model) =>
      !model.get("archivedAt")?
  ).property('controllers.categories.model.length')

  actions:
    create: (seminar) ->
      if App.Session.authUser == undefined || App.Session.authUser.get("can_create_seminars") == false
        seminar.rollback()
        Flash.NM.push 'You are not authorized to access this page', "danger"
      else
        self = @
        seminar.set "startAt", moment(@get('startAt')).toDate()
        seminar.set "endAt", moment(seminar.get("startAt")).add('hours', 1).toDate unless seminar.get("endAt")?
        seminar.save({associations: true}).then(
          (->
            Flash.NM.push 'Seminar successfully created', "success"
            self.send "closeModal"
            $('#calendar').fullCalendar('refetchEvents')
            # $("#calendar").fullCalendar('renderEvent', seminar.get("forFullCalendar"), true)
          ),
          ((error) ->
            self.setValidationErrors error.message
          )
        )

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
