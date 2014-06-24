App.UsersNewPasswordRoute = Ember.Route.extend
  model: (params) ->
    params.token
  setupController: (controller, model) ->
    @_super controller, model
