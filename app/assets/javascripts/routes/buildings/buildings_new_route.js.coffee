App.BuildingsNewRoute = Ember.Route.extend Ember.SimpleAuth.AuthenticatedRouteMixin,

  beforeModel: (transition)->
    @_super(transition)
    if @session.isAuthenticated && @session.get("user.can_create_buildings") != true
      Flash.NM.push 'You are not authorized to access this page', "info"
      @goBackOr 'buildings'

  model: ->
    @store.createRecord "building"

  afterModel: (model, transition) ->
    @send 'openModal', 'buildings', 'new', model
    transition.abort()
