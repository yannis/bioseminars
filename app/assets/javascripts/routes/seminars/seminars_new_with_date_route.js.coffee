# App.SeminarsNewWithDateRoute = App.SeminarsNewRoute.extend

#   model: (params)->
#     year: params.year || moment().format('YYYY')
#     month: params.month || moment().format('MM')
#     day: params.year || moment().format('DD')

#   setupController: (controller, model) ->
#     seminar = @store.createRecord "seminar",
#       startAt: moment("#{model.year}-#{model.month}-#{model.day}")
#     seminar.get("categorisations").addObject @store.createRecord("categorisation")
#     seminar.get("hostings").addObject @store.createRecord("hosting")
#     @store.find("location").then (locations)->
#       seminar.set "location", locations.sortBy("name").get("firstObject")
#     @_super controller, seminar

#     controller.set 'selectCategories', @store.find("category")
#     controller.set 'selectLocations', @store.find("location")
#     controller.set 'selectHosts', @store.find "host"
#     controller.set 'pageTitle', "Create a seminar on #{model.year}-#{model.month}-#{model.day}"


App.SeminarsNewWithDateRoute = Ember.Route.extend

  afterModel: (model, transition) ->
    if App.Session.authUser == undefined || App.Session.authUser.get("can_create_seminars") == false
      model.rollback()
      Flash.NM.push 'You are not authorized to access this page', "danger"
      @goBackOr '/'
    else
      seminar = @store.createRecord "seminar",
        startAt: moment("#{model.year}-#{model.month}-#{model.day} 12:00")
      seminar.get("categorisations").addObject @store.createRecord("categorisation")
      seminar.get("hostings").addObject @store.createRecord("hosting")

      @controllerFor('seminars_new').set "content", seminar
      @controllerFor('seminars_new').set "pageTitle", "Create a seminar on #{model.year}-#{model.month}-#{model.day}"

      if @controllerFor('locations').get("model").length == 0
        @controllerFor('locations').set "model", @store.find "location" # do not set "content"
      @controllerFor('locations').set "sortProperties", ["name"]
      @controllerFor('locations').set "sortAscending", true

      if @controllerFor('categories').get("model").length == 0
        @controllerFor('categories').set "model", @store.find "category" # do not set "content"
      @controllerFor('categories').set "sortProperties", ["archivedAt", "position"]
      @controllerFor('categories').set "sortAscending", true

      if @controllerFor('hosts').get("model").length == 0
        @controllerFor('hosts').set "model", @store.find "host" # do not set "content"
      @controllerFor('hosts').set "sortProperties", ["name"]
      @controllerFor('hosts').set "sortAscending", true

      @send 'openModal', 'seminars', 'new', seminar
      transition.abort()
