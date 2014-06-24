App.SeminarsNewRoute = Ember.Route.extend Ember.SimpleAuth.AuthenticatedRouteMixin,

  beforeModel: (transition)->
    @_super(transition)
    if @session.get("user.can_create_seminars") != true
      Flash.NM.push 'You are not authorized to access this page', "info"
      @goBackOr '/'

  model: (params) ->
    seminar = @store.createRecord "seminar"
    # seminar.get("categorisations").addObject @store.createRecord("categorisation")
    # seminar.get("hostings").addObject @store.createRecord("hosting")
    return seminar

  afterModel: (model, transition) ->
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

    @send 'openModal', 'seminars', 'new', model

    transition.abort()
