App.CalendarSeminarRoute = Em.Route.extend
  model: (params) ->
    @store.find("seminar", params.seminar_id)

  # actions:
  #   willTransition: ->
  #     element = $(".fc-event-#{@currentModel.get("id")}")
  #     element.qtip('api').hide() if element



  deactivate: ->
    # element = $(".fc-event-#{@currentModel.get("id")}")
    # element.qtip('api').hide() if element.length > 0
    $(".calendar-qtip").hide()
