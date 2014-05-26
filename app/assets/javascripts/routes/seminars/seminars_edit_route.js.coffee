App.SeminarsEditRoute = Ember.Route.extend
  model: (params) ->
    @store.find "seminar", params.seminar_id

  afterModel: (model, transition) ->
    if model.get('updatable')

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

      @send 'openModal', 'seminars', 'edit', model

      transition.abort()
    else
      Flash.NM.push 'You are not authorized to access this page', "info"
      @goBackOr '/'
