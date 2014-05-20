App.BuildingsEditRoute = Ember.Route.extend
  model: (params) ->
    @store.find "building", params.building_id

  afterModel: (building, transition) ->
    if building.get('updatable')
      @send 'openModal', 'buildings', 'edit', building
      transition.abort()
    else
      Flash.NM.push 'You are not authorized to access this page', "danger"
      @goBackOr 'buildings'
