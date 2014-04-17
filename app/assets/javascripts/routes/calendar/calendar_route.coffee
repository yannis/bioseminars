App.CalendarRoute = Em.Route.extend

  model: (params) ->
    year: params.year || moment().format('YYYY')
    month: params.month || moment().format('MM')
    day: params.year || moment().format('DD')
    type: params.type || "month"

  serialize: (model) ->
    return {
      year: model.year,
      month: model.month,
      day: model.day,
      type: model.type
    } if model


  setupController: (controller, model) ->
    @_super controller, model
    controller.set 'seminars', @store.find "seminar",
      after: moment("#{model.year}-#{model.month}-01").subtract('months', 1).date(0).format("YYYYMMDD")
      before: moment("#{model.year}-#{model.month}-01").add('months', 1).date(0).format("YYYYMMDD")
    @controllerFor('categories').set "model", @store.find "category" # do not set "content"
    @controllerFor('categories').set "sortProperties", ["position"]
    @controllerFor('categories').set "sortAscending", true
