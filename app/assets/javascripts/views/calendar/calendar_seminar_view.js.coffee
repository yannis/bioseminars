App.CalendarSeminarView = Ember.View.extend
  templateName: 'calendar/calendar_seminar'

  didInsertElement: (->

    seminar = @get("controller.model")

    if @get("parentView.fullCalendarRendered") == true && seminar.get("location.building.isLoaded") == true

      console.log "CAALLLLLED"

      element = $(".fc-event-#{seminar.get("id")}")

      element.qtip
        html: true
        override: true
        id: "tooltip-#{seminar.get('id')}"
        style:
          classes: 'qtip-bootstrap calendar-qtip'
        content:
          title: ->
            $(".calendar-seminar-tooltip-title").html()
          text: ->
            $(".calendar-seminar-tooltip-content").html()
        position:
          my: 'left center'
          at: 'right center'
        show:
          event: 'click'
          ready: true
          solo: true
        hide:
          fixed: true
          event: 'click'

  ).observes("parentView.fullCalendarRendered", "controller.model.id")
