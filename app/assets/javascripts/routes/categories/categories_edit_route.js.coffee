App.CategoriesEditRoute = Ember.Route.extend
  model: (params) ->
    @store.find "category", params.category_id

  afterModel: (model, transition) ->
    unless model.get('updatable')
      Flash.NM.push 'You are not authorized to access this page', "danger"
      window.history.go(-1)

  setupController: (controller, model) ->
    @_super controller, model
    controller.set('pageTitle', "Edit category “#{model.get('name')}”")