App.AboutRoute = Em.Route.extend

  setupController: (controller, model) ->
    @_super controller, model
    title = "About bioSeminars"
    controller.set 'pageTitle', title
    document.title = title

