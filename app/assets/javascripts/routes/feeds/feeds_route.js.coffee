App.FeedsRoute = Em.Route.extend  App.CategoriesSelectionRouteMixin,

  setupController: (controller, model) ->
    @_super controller, model
    title = "Get your personal seminar feed"
    controller.set 'pageTitle', title
    document.title = title
    # controller.set "categories", @store.find "category" # do not set "content"

