App.SeminarsPastRoute = Ember.Route.extend
  model: ->
    App.Seminar.find
      before: moment().format("YYYY-MM-DD")

