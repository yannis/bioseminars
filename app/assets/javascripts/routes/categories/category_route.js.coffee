App.CategoryRoute = Ember.Route.extend  App.CategoriesSelectionRouteMixin,
  model: (params) ->
    @store.find( "category", params.category_id).then(
      null,
      ((error) =>
        Flash.NM.push JSON.parse(error.responseText)["message"], "danger"
        return null
      )
    )
  setupController: (controller, model) ->
    @_super controller, model
    # controller.set 'seminars', model.get("seminars")
