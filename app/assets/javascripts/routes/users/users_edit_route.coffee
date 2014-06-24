App.UsersEditRoute = Ember.Route.extend Ember.SimpleAuth.AuthenticatedRouteMixin,
  model: (params) ->
    @store.find("user", params.user_id).then(
      null,
      ((error) ->
        Flash.NM.push JSON.parse(error.responseText)["errors"], "info"
      )
    )

  afterModel: (model, transition) ->
    if model? && model.get('updatable')
      @send 'openModal', 'users', 'edit', model
      transition.abort()
    else
      Flash.NM.push 'You are not authorized to access this page', "info"
      @goBackOr '/'
      # transition.abort()
