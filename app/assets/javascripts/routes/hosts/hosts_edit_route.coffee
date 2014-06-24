App.HostsEditRoute = Ember.Route.extend Ember.SimpleAuth.AuthenticatedRouteMixin,
  model: (params) ->
    @store.find "host", params.host_id

  afterModel: (host, transition) ->
    if host.get('updatable')
      @send 'openModal', 'hosts', 'edit', host
      transition.abort()
    else
      Flash.NM.push 'You are not authorized to access this page', "info"
      @goBackOr 'hosts'
