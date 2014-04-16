
App.SessionDestroyRoute = Ember.Route.extend
  renderTemplate: (controller, model) ->
    controller.logout()
