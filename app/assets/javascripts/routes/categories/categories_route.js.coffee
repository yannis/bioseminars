App.CategoriesRoute = Ember.Route.extend
  model: ->
    @store.find "category"

  setupController: (controller, model) ->
    @_super controller, model
    title = "All categories"
    controller.set 'pageTitle', title
    document.title = title
