App.BuildingsEditRoute = Ember.Route.extend
  model: (params) ->
    @store.find "building", params.building_id

  afterModel: (model, transition) ->
    unless model.get('updatable')
      Flash.NM.push 'You are not authorized to access this page', "danger"
      window.history.go(-1)

  setupController: (controller, model) ->
    @_super controller, model
    controller.set('pageTitle', "Edit building “#{model.get('name')}”")
