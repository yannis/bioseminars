App.CalendarSeminarController = Em.ObjectController.extend
  needs: ['seminar']
  actions:
    destroy: (seminar)->
      @get('controllers.seminar').send 'destroy', seminar
