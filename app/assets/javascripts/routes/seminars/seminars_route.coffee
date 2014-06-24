App.SeminarsRoute = Ember.Route.extend App.CategoriesSelectionRouteMixin, App.LoadSeminarsRouteMixin,
  model: ->
    @getSeminars()

  perPage: 10

  getSeminars: (page = 1) ->
    self = this
    @store.find( "seminar",
      order: "desc"
      page: page
      per_page: @perPage
    )

  setupController: (controller, model) ->
    @_super controller, model
    controller.set "content", model.get("content")
    title = "All seminars"
    controller.set 'pageTitle', title
    document.title = title
    controller.set "page", 1
