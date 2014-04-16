App.IframeRoute = Ember.Route.extend

  model: (params) ->
    year: params.year || moment().format('YYYY')
    month: params.month || moment().format('MM')
    day: params.year || moment().format('DD')
    type: params.type || "month"
    categories: params.categories

  serialize: (model) ->
    return {
      year: model.year,
      month: model.month,
      day: model.day,
      type: model.type
      categories: model.categories
    } if model


  setupController: (controller, model) ->
    @_super controller, model
    controller.set 'iframe', true
    controller.set 'seminars', @store.find "seminar",
      after: moment("#{model.year}-#{model.month}-01").subtract('months', 1).date(0).format("YYYYMMDD")
      before: moment("#{model.year}-#{model.month}-01").add('months', 1).date(0).format("YYYYMMDD")
      categories: model.categories
