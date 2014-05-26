App.LocationsNewRoute = Ember.Route.extend Ember.SimpleAuth.AuthenticatedRouteMixin,

  beforeModel: (transition)->
    @_super(transition)
    if @session.isAuthenticated && @session.get("user.can_create_locations") != true
      Flash.NM.push 'You are not authorized to access this page', "info"
      @goBackOr 'locations'

  model: ->
    @store.createRecord "location"

  afterModel: (location, transition) ->
    @send 'openModal', 'locations', 'new', location
    @controllerFor('buildings').set('content', @store.find( "building"))
    @controllerFor('buildings').set "sortProperties", ["name"]
    @controllerFor('buildings').set "sortAscending", true
    transition.abort()
