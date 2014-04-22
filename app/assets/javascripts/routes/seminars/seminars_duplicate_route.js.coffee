App.SeminarsDuplicateRoute = Ember.Route.extend
  originalSeminar: null

  model: (params) ->
    @store.find "seminar", params.seminar_id

  beforeModel: (transition) ->
    setTimeout (->
      if App.Session.authUser == undefined || App.Session.authUser.get("can_create_seminars") == false
        Flash.NM.push 'You are not authorized to access this page', "danger"
        window.history.go(-1)
    ), 500

  setupController: (controller, model) ->
    newSeminar = @store.createRecord "seminar",
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
      newSeminar.get("categorisations").addObject @store.createRecord("categorisation", {category: category})
    model.get('hosts').forEach (host) ->
      newSeminar.get("hostings").addObject @store.createRecord("hosting", {host: host})
    @_super controller, newSeminar
    controller.set 'selectCategories', @store.find("category")
    controller.set 'selectLocations', @store.find("location")
    controller.set 'selectHosts', @store.find "host"
    controller.set "pageTitle", "Duplicate seminar “#{model.get('title')}”"

