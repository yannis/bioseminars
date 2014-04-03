App.SeminarsNextRoute = Ember.Route.extend App.CategoriesSelectionRouteMixin, App.LoadSeminarsRouteMixin,
  model: ->
    @getSeminars()

  perPage: 10

  getSeminars: (page = 1) ->
    self = this
    @store.find( "seminar",
      after: moment().subtract('days', 1).format("YYYY-MM-DD")
      order: "asc"
      page: page
      per_page: @perPage
    )
    # @store.filter( "seminar", {
    #     after: moment().subtract('days', 1).format("YYYY-MM-DD"),
    #     order: "asc",
    #     page: page,
    #     per_page: @perPage
    #   },
    #   (seminar) ->
    #     seminar.get("show")
    # )

  setupController: (controller, model) ->
    @_super controller, model
    controller.set "content", model.get("content")
    title = "Next seminars"
    controller.set 'pageTitle', title
    document.title = title
    controller.set "page", 1
