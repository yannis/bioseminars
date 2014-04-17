App.CalendarSeminarView = Ember.View.extend
  templateName: 'seminars/seminar'

  highlight: (->
    $('.panel.seminar .panel-body').effect("highlight", "slow")
  ).observes('controller.model.id')
