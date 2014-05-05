App.CategoriesRoute = Ember.Route.extend
  model: ->
    if App.Session.authUser? && App.Session.authUser.get("admin") == true
      @store.find "category"
    else
      @store.find "category",
        archivedAt: null

  setupController: (controller, model) ->
    @_super controller, model
    title = "All categories"
    controller.set 'pageTitle', title
    document.title = title
