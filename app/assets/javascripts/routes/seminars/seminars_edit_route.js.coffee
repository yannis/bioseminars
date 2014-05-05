App.SeminarsEditRoute = Ember.Route.extend App.CategoriesSelectionRouteMixin,
  model: (params) ->
    @store.find "seminar", params.seminar_id

  afterModel: (model, transition) ->
    unless model.get('updatable')
      Flash.NM.push 'You are not authorized to access this page', "danger"
      window.history.go(-1)
      # if document.referrer && document.referrer.match("bioseminars") != null then window.history.back() else transitionTo("/")

  setupController: (controller, model) ->
    @_super controller, model
    controller.set "pageTitle", "Edit seminar “#{model.get('title')}”"

    if @controllerFor('locations').get("model").length == 0
      @controllerFor('locations').set "model", @store.find "location" # do not set "content"
    @controllerFor('locations').set "sortProperties", ["name"]
    @controllerFor('locations').set "sortAscending", true

    if @controllerFor('hosts').get("model").length == 0
      @controllerFor('hosts').set "model", @store.find "host" # do not set "content"
    @controllerFor('hosts').set "sortProperties", ["name"]
    @controllerFor('hosts').set "sortAscending", true
