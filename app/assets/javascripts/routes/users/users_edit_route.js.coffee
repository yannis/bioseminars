App.UsersEditRoute = Ember.Route.extend
  model: (params) ->
    @store.find("user", params.user_id).then(
      null,
      ((error) ->
        Flash.NM.push JSON.parse(error.responseText)["message"], "danger"
        window.history.go(-1)
      )
    )

  afterModel: (model, transition) ->
    if model.get('updatable')
      @send 'openModal', 'users', 'edit', model
      transition.abort()
    else
      Flash.NM.push 'You are not authorized to access this page', "danger"
      @goBackOr '/'
