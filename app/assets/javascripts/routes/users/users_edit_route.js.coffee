App.UsersEditRoute = Ember.Route.extend
  model: (params) ->
    @store.find("user", params.user_id).then(
      null,
      ((error) ->
        debugger
        Flash.NM.push JSON.parse(error.responseText)["message"], "danger"
        window.history.go(-1)
      )
    )
  #     window.history.go(-1)

  afterModel: (model, transition) ->
    unless model.get('updatable')
      Flash.NM.push 'You are not authorized to access this page', "danger"
      window.history.go(-1)

  setupController: (controller, model) ->
    @_super controller, model
    controller.set('pageTitle', "Edit user “#{model.get('name')}”")
