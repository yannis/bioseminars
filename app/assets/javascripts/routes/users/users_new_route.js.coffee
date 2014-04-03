App.UsersNewRoute = Ember.Route.extend
  model: (params) ->
    @store.createRecord "user"

  beforeModel: (transition) ->
    if App.Session.authUser == undefined || App.Session.authUser.get("can_create_users") == false
      Flash.NM.push 'You are not authorized to access this page', "danger"
      window.history.go(-1)

  setupController: (controller, model) ->
    @_super controller, model
