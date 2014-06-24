App.HostsNewRoute = Ember.Route.extend Ember.SimpleAuth.AuthenticatedRouteMixin,

  beforeModel: (transition)->
    @_super(transition)
    if @session.isAuthenticated && @session.get("user.can_create_hosts") != true
      Flash.NM.push 'You are not authorized to access this page', "info"
      @goBackOr 'hosts'

  model: (params) ->
    @store.createRecord "host"

  afterModel: (model, transition) ->
    @send 'openModal', 'hosts', 'new', model
    transition.abort()
