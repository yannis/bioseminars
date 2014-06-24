App.LocationRoute = Ember.Route.extend
  model: (params) ->
    @store.find( "location", params.location_id)
