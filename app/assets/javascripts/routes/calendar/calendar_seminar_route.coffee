App.CalendarSeminarRoute = Em.Route.extend
  model: (params) ->
    @store.find "seminar", params.seminar_id

