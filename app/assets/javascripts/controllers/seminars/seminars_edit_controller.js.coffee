App.SeminarsEditController = Ember.ObjectController.extend App.ValidationErrorsMixin,

  pageTitle: (->
    "Edit seminar “#{@get('model.title')}”"
  ).property("model.title")

  needs: ["categories", "hosts", "locations"]

  limitedCategories: (->
    cats = @get('controllers.categories')
    activeCats = cats.filter (model) =>
      !model.get("archivedAt")?
  ).property('controllers.categories.model.length')


  actions:

    update: (seminar) ->
      self = @
      seminar.set "startAt", moment(@get('startAt')).toDate()
      seminar.set "endAt", moment(seminar.get("startAt")).add('hours', 1).toDate unless seminar.get("endAt")?
      seminar.save({associations: true}).then(
        ((seminar)->
          Flash.NM.push 'Seminar successfully updated', "success"
          self.send "closeModal"
        ),
        ((error) ->
          self.setValidationErrors error.message
        )
      )

    addHosting: (seminar) ->
      seminar.get('hostings').addObject @store.createRecord("hosting", {seminar: seminar})

    removeHosting: (hosting) ->
      @get("model.hostings").removeObject(hosting)

    addCategorisation: (seminar) ->
      seminar.get('categorisations').addObject @store.createRecord("categorisation", {seminar: seminar})

    removeCategorisation: (categorisation) ->
      @get("model.categorisations").removeObject(categorisation)
