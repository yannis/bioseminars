App.LocationsRoute = Ember.Route.extend
  model: ->
    @store.find "location"
  setupController: (controller, model) ->
    @_super controller, model
    title = "All rooms"
    controller.set 'pageTitle', title
    document.title = title
