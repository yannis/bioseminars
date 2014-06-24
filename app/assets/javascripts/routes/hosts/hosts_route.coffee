App.HostsRoute = Ember.Route.extend
  model: ->
    @store.find "host"
  setupController: (controller, model) ->
    @_super controller, model
    title = "All hosts"
    controller.set 'pageTitle', title
    document.title = title
