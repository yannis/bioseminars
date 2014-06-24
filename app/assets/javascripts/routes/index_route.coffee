App.IndexRoute = Ember.Route.extend
  # redirect: ->
  #   @transitionTo "calendar"
  redirect: ->
    type = 'month'
    year = moment().format('YYYY')
    month = moment().format('MM')
    day = moment().format('DD')
    dateObj = {year: year, month: month, day: day, type: type}
    @transitionTo "calendar", dateObj
