App.SeminarsNewWithDateRoute = App.SeminarsNewRoute.extend

  model: (params)->
    year: params.year || moment().format('YYYY')
    month: params.month || moment().format('MM')
    day: params.year || moment().format('DD')

  setupController: (controller, model) ->
    seminar = @store.createRecord "seminar",
      startAt: moment("#{model.year}-#{model.month}-#{model.day}")
    seminar.get("categorisations").addObject @store.createRecord("categorisation")
    seminar.get("hostings").addObject @store.createRecord("hosting")
    @store.find("location").then (locations)->
      seminar.set "location", locations.sortBy("name").get("firstObject")
    @_super controller, seminar

    controller.set 'selectCategories', @store.find("category")
    controller.set 'selectLocations', @store.find("location")
    controller.set 'selectHosts', @store.find "host"
    controller.set 'pageTitle', "Create a seminar on #{model.year}-#{model.month}-#{model.day}"
