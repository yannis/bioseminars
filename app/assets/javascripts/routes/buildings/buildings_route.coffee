App.BuildingsRoute = Ember.Route.extend
  model: ->
    buildings = @store.find "building"
  setupController: (controller, model) ->
    @_super controller, model
    title = "All buildings"
    controller.set 'pageTitle', title
    document.title = title

