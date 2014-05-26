App.CalendarRoute = Em.Route.extend  App.CategoriesSelectionRouteMixin,

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
    window.sess = this.session
    @_super controller, model
