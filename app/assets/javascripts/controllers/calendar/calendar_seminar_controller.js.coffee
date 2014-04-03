App.CalendarSeminarController = Em.ObjectController.extend
  actions:
    close: ->
      this.transitionToRoute('calendar')
      # window.history.go(-1)

