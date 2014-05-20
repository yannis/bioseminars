App.HostsEditRoute = Ember.Route.extend
  model: (params) ->
    @store.find "host", params.host_id

  afterModel: (host, transition) ->
    if host.get('updatable')
      @send 'openModal', 'hosts', 'edit', host
      transition.abort()
    else
      Flash.NM.push 'You are not authorized to access this page', "danger"
      @goBackOr 'hosts'
