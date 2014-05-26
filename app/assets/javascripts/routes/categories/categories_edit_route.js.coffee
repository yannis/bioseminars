App.CategoriesEditRoute = Ember.Route.extend Ember.SimpleAuth.AuthenticatedRouteMixin,
  model: (params) ->
    @store.find "category", params.category_id

  afterModel: (model, transition) ->
    if model.get('updatable')
      @send 'openModal', 'categories', 'edit', model
      transition.abort()
    else
      Flash.NM.push 'You are not authorized to access this page', "info"
      @goBackOr 'categories'
