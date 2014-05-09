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


  # setTooltip: (->
  #   seminar = @get("controller.model")
  #   if @get("parentView.fullCalendarRendered") == true && seminar.get("location.building.isLoaded") == true
  #     element = $(".fc-event-#{seminar.get("id")}")

  #     element.qtip
  #       html: true
  #       override: true
  #       id: "tooltip-#{seminar.get('id')}"
  #       style:
  #         classes: 'qtip-bootstrap calendar-qtip'
  #       content:
  #         title: @tooltipTitle()
  #         text: @tooltipText()
  #       position:
  #         my: 'left center'
  #         at: 'right center'
  #       show:
  #         event: 'click'
  #         ready: true
  #         solo: true
  #       hide:
  #         fixed: true
  #         event: 'click'
  # ).observes("controller.model.location.building", "controller.model.id", "parentView.fullCalendarRendered")

  # tooltipTitle: ->
  #   seminar = @get("controller.model")
  #   "<p><span class='category-color' style='background-color: #{seminar.get('color')}'></span>"+
  #   "<em>#{seminar.get('date_time_location_and_category')}</em></p>"+
  #   "<h4>#{seminar.get('title')}</h4>"

  # tooltipText: ->
  #   seminar = @get("controller.model")
  #   text = ""
  #   text += "<p><em>by</em> <strong>#{seminar.get("speakerName")}</strong> (#{seminar.get("speakerAffiliation")})</p>"
  #   text += "<p><em>hosted by</em> "
  #   text += seminar.get("hosts").map((host)->
  #     "<strong>#{host.get('name')}</strong> "
  #   ).join(", ")
  #   text += "</p>"
  #   text += "<p>"
  #   text += "<a href='/#/seminars/#{seminar.get('id')}'>permalink</a>"
  #   if seminar.get("updatable")
  #     text += "<a href='/#/seminars/#{seminar.get('id')}/edit'>Edit</a>"
  #   # if seminar.get("destroyable")
  #   #   text += "<a href='/#/seminars/#{seminar.get('id')}/edit'>Edit</a>"
  #   text += "</p>"



# - if seminar.only_one_speaker?
#   %p
#     by
#     =raw seminar.speakers.map{|s| s.bold_name_and_affiliation}.join(', ')
# - else
#   %dl
#     - for speaker in seminar.speakers
#       %dt
#         = speaker.title
#       %dd
#         %span.by
#           by
#         =raw speaker.name_and_affiliation
# - if seminar.internal?
#   %p.alert_internal
#     This seminar is not public
# %p
#   = seminar.when_and_where
# - unless seminar.hosts.empty?
#   %p
#     Hosted by
#     = seminar.hosts.map{|s| mail_to(s.email, s.name, :encode => 'hex')}.join(', ').html_safe
# - unless seminar.documents.blank? and seminar.pictures.blank? and seminar.publications.blank?
#   %p
#     - message = []
#     - message << pluralize(seminar.documents.size, 'document') unless seminar.documents.blank?
#     - message << pluralize(seminar.pictures.size, 'picture') unless seminar.pictures.blank?
#     - message << pluralize(seminar.publications.size, 'publication') unless seminar.publications.blank?
#     = link_to message.join(', ')+' are attached to this seminar', seminar_path(seminar)
# %p.admin_links
#   - links = [link_to('Details', seminar_path(seminar))]
#   - links << link_to('Website', seminar.url) unless seminar.url.blank?
#   - links << link_to('Save in iCal', seminar_path(seminar, :format => 'ics'))
#   - links << edit_link(seminar) if can?(:update, seminar)
#   - links << destroy_link(seminar) if can?(:destroy, seminar)
#   =raw links.join(' · ')
# - unless seminar.user.blank?
#   %p{:style => 'margin: 0 .1em; padding: 0; font-size: smaller; text-align: right'}
#     Created by
#     = seminar.user.name
