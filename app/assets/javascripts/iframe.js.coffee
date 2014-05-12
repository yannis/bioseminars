#= require jquery
#= require jquery_ujs
#= require modernizr
#= require bootstrap
#= require moment
#= require fullcalendar

$ ->
  $('.iframe-calendar').fullCalendar
    axisFormat: 'H:mm'
    header:
      left: 'prev,next today'
      center: 'title'
      right: 'month,agendaWeek,agendaDay'
    firstDay: 1
    timeFormat: 'H:mm'
    disableDragging: true
    disableResizing: true
    weekMode: 'fluid'

    events:
      url: "/api/v2/seminars.fullcalendar"
      data:
        categories: location.search.split('categories=')[1]

    eventRender: (event, element) ->
      $(element).on "click", (e)->
        e.preventDefault()
        $('.fc-event.fc-event-hori').not(@).popover('hide')
      $(element).popover
        placement: 'auto'
        html: true
        title: popoverTitle(event)
        content: popoverContent(event)

  popoverTitle = (event)->
    "<em>#{event.schedule}, #{event.location}</em>
    <h4>#{event.full_title}</h4>"

  popoverContent = (event)->
    "<p><em>by</em> #{event.speaker}</p>
    <p><em>Hosted by</em> #{popoverHosts(event)}</p>
    <p>#{popoverLinks event}</p>"

  popoverHosts = (event)->
    event.hosts.map((h)->
      h.name
    ).join(", ")

  popoverLinks = (event) ->
    "<a href='http://#{window.location.host}#/seminars/#{event.id}' target='_blank' class='btn btn-xs btn-default'>permalink</a>"

