App.LocationsEditRoute = Ember.Route.extend Ember.SimpleAuth.AuthenticatedRouteMixin,
  model: (params) ->
    @store.find "location", params.location_id

  afterModel: (model, transition) ->
    if model.get('updatable')
      @controllerFor('buildings').set('content', @store.find( "building"))
      @send 'openModal', 'locations', 'edit', model
      transition.abort()
    else
      Flash.NM.push 'You are not authorized to access this page', "info"
      @goBackOr 'locations'
