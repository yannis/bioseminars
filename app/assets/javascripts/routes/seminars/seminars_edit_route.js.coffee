App.SeminarsEditRoute = Ember.Route.extend
  model: (params) ->
    @store.find "seminar", params.seminar_id

  afterModel: (model, transition) ->
    unless model.get('updatable')
      Flash.NM.push 'You are not authorized to access this page', "danger"
      window.history.go(-1)
      # if document.referrer && document.referrer.match("bioseminars") != null then window.history.back() else transitionTo("/")

  setupController: (controller, model) ->
    @_super controller, model
    controller.set 'selectCategories', @store.find "category"
    controller.set 'selectLocations', @store.find "location"
    controller.set 'selectHosts', @store.find "host"
    controller.set "pageTitle", "Edit seminar “#{model.get('title')}”"
    # controller.set 'selectHostings', @store.find "hosting"
