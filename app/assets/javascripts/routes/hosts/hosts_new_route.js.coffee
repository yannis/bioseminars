App.HostsNewRoute = Ember.Route.extend

  model: (params) ->
    @store.createRecord "host"

  afterModel: (model, transition) ->
    if App.Session.authUser == undefined || App.Session.authUser.get("can_create_hosts") == false
      model.rollback()
      Flash.NM.push 'You are not authorized to access this page', "danger"
      @goBackOr 'hosts'
    else
      @send 'openModal', 'hosts', 'new', model
      transition.abort()
