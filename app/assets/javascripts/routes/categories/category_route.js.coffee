App.CategoryRoute = Ember.Route.extend
  model: (params) ->
    @store.find "category", params.category_id
  setupController: (controller, model) ->
    @_super controller, model
    # controller.set 'seminars', model.get("seminars")
