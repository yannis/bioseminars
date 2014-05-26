App.CategoriesRoute = Ember.Route.extend
  model: ->
    if @session? && @session.get("user.can_create_categories")
      @store.find "category"
    else
      @store.find "category",
        archivedAt: null

  setupController: (controller, model) ->
    @_super controller, model
    title = "All categories"
    controller.set 'pageTitle', title
    document.title = title
