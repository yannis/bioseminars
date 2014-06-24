App.FeedsDocumentationRoute = Em.Route.extend

  setupController: (controller, model) ->
    @_super controller, model
    title = "API documentation"
    controller.set 'pageTitle', title
    controller.set 'apiUrl', "http://"+window.location.hostname+"/api/v2/seminars"
    document.title = title

