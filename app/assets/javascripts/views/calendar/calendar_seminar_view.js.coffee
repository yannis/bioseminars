App.CalendarSeminarView = Ember.View.extend
  templateName: 'seminars/seminar'

  didInsertElement: ->


  # setPosition: (->
  #   content = @controller.get('content')
  #   element = $(".calendar-seminar")
  #   calendarElement = $(".fc-event-#{content.get('id')}")
  #   if calendarElement.length
  #     element.position
  #       my: "left center"
  #       at: "right center"
  #       of: calendarElement
  #       collision: "none"
  #   else
  #     $("#calendar").on 'DOMNodeInserted', ".fc-event-#{content.get('id')}", =>
  #       @setPosition()
  # ).observes('controller.content')

  highlight: (->
    console.log "$('.panel.seminar')", $('.panel.seminar')
    $('.panel.seminar').effect( "highlight", 'slow' )
  ).observes('controller.model.id')
