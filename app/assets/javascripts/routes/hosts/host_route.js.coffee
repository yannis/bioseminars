App.HostRoute = Ember.Route.extend
  model: (params) ->
    @store.find "host", params.host_id
