App.UsersNewRoute = Ember.Route.extend

  model: ->
    @store.createRecord "user"

  afterModel: (model, transition) ->
    if App.Session.authUser == undefined || App.Session.authUser.get("can_create_users") == false
      model.rollback()
      Flash.NM.push 'You are not authorized to access this page', "danger"
      @goBackOr '/'
    else
      @send 'openModal', 'users', 'new', model
      transition.abort()
