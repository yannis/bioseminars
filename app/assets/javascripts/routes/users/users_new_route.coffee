App.UsersNewRoute = Ember.Route.extend Ember.SimpleAuth.AuthenticatedRouteMixin,

  beforeModel: (transition)->
    @_super(transition)
    if @session.isAuthenticated && @session.get("user.can_create_users") != true
      Flash.NM.push 'You are not authorized to access this page', "info"
      @goBackOr '/'

  model: ->
    @store.createRecord "user"

  afterModel: (model, transition) ->
    @send 'openModal', 'users', 'new', model
    transition.abort()
