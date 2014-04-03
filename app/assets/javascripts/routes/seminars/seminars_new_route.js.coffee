App.SeminarsNewRoute = Ember.Route.extend
  model: (params) ->
    self = @
    seminar = @store.createRecord("seminar")
    seminar.get("categorisations").addObject @store.createRecord("categorisation")
    seminar.get("hostings").addObject @store.createRecord("hosting")
    seminar

  beforeModel: (transition) ->
    setTimeout (->
      if App.Session.authUser == undefined || App.Session.authUser.get("can_create_seminars") == false
        Flash.NM.push 'You are not authorized to access this page', "danger"
        window.history.go(-1)
    ), 500

  setupController: (controller, model) ->
    @_super controller, model
    controller.set 'selectCategories', @store.find "category"
    controller.set 'selectLocations', @store.find "location"
    controller.set 'selectHosts', @store.find "host"
    controller.set 'pageTitle', "Create a seminar"
