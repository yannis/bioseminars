App.CalendarController = Em.ObjectController.extend App.CategoriesSelectionControllerMixin,

  needs: ["seminars"]

  reRenderEvents: (->
    $('#calendar').fullCalendar("refetchEvents")
  ).property('controllers.seminars@each.speaker_name')
