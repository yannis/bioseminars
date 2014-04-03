App.LocationsNewRoute = Ember.Route.extend
  model: (params) ->
    @store.createRecord "location"

  afterModel: (model, transition) ->
    if App.Session.authUser == undefined || App.Session.authUser.get("can_create_locations") == false
      model.deleteRecord()
      Flash.NM.push 'You are not authorized to access this page', "danger"
      window.history.go(-1)

  setupController: (controller, model) ->
    @_super controller, model
    controller.set 'selectBuildings', @store.find "building"
    controller.set 'pageTitle', "New location"
