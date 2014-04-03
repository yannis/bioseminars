App.SeminarsDuplicateRoute = Ember.Route.extend
  originalSeminar: null

  model: (params) ->
    @store.find "seminar", params.seminar_id

  # afterModel: (model, transition) ->
  #   unless model.get('updatable')
  #     Ember.FlashQueue.pushFlash('alert-error', 'Not authorized')
  #     window.history.go(-1)

  setupController: (controller, model) ->
    newSeminar = App.Seminar.createRecord
      title: null
      startAt: model.get("startAt")
      endAt: model.get("endAt")
      internal: model.get("internal")
      all_day: model.get("all_day")
      location: model.get("location")
      readable: model.get("readable")
      updatable: model.get("updatable")
      destroyable: model.get("destroyable")
    model.get('categories').forEach (category) ->
      newSeminar.get("categorisations").pushObject App.Categorisation.createRecord {category: category}
    model.get('hosts').forEach (host) ->
      newSeminar.get("hostings").pushObject App.Hosting.createRecord {host: host}
    @_super controller, newSeminar
    controller.set 'selectCategories', @store.find "category"
    controller.set 'selectLocations', @store.find "location"
    controller.set 'selectHosts', @store.find "host"
    controller.set "pageTitle", "Duplicate seminar “#{model.get('title')}”"
    # debugger
