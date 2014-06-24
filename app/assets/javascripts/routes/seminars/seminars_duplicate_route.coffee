App.SeminarsDuplicateRoute = Ember.Route.extend Ember.SimpleAuth.AuthenticatedRouteMixin,

  beforeModel: (transition)->
    @_super(transition)
    if @session.get("user.can_create_seminars") != true
      Flash.NM.push 'You are not authorized to access this page', "info"
      @goBackOr '/'

  model: (params) ->
    @store.find "seminar", params.seminar_id

  afterModel: (model, transition) ->
    newSeminar = @store.createRecord "seminar",
      title: null
      startAt: model.get("startAt")
      endAt: model.get("endAt")
      internal: model.get("internal")
      all_day: model.get("all_day")
      location: model.get("location")
      readable: model.get("readable")
      updatable: model.get("updatable")
      destroyable: model.get("destroyable")
    model.get('categories').forEach (category) ->
      newSeminar.get("categories").addObject category
    model.get('hosts').forEach (host) ->
      newSeminar.get("hosts").addObject host

    @controllerFor('seminars_new').set "content", newSeminar
    @controllerFor('seminars_new').set "pageTitle", "Duplicate seminar “#{model.get('title')}”"

    if @controllerFor('locations').get("model").length == 0
      @controllerFor('locations').set "model", @store.find "location" # do not set "content"
    @controllerFor('locations').set "sortProperties", ["name"]
    @controllerFor('locations').set "sortAscending", true

    if @controllerFor('categories').get("model").length == 0
      @controllerFor('categories').set "model", @store.find "category" # do not set "content"
    @controllerFor('categories').set "sortProperties", ["archivedAt", "position"]
    @controllerFor('categories').set "sortAscending", true

    if @controllerFor('hosts').get("model").length == 0
      @controllerFor('hosts').set "model", @store.find "host" # do not set "content"
    @controllerFor('hosts').set "sortProperties", ["name"]
    @controllerFor('hosts').set "sortAscending", true

    @send 'openModal', 'seminars', 'new', newSeminar
    transition.abort()
