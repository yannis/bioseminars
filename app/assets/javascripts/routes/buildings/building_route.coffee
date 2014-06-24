App.BuildingRoute = Ember.Route.extend
  model: (params) ->
    @store.find "building", params.building_id
  # setupController: (controller, model) ->
  #   @_super controller, model
