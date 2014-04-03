App.SeminarRoute = Ember.Route.extend
  model: (params) ->
    @store.find("seminar", params.seminar_id)
