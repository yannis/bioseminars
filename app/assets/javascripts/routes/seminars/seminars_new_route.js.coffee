App.SeminarsNewRoute = Ember.Route.extend App.CategoriesSelectionRouteMixin,
  model: (params) ->
    seminar = @store.createRecord "seminar"
    seminar.get("categorisations").addObject @store.createRecord("categorisation")
    seminar.get("hostings").addObject @store.createRecord("hosting")
    @store.find("location").then (locations)->
      seminar.set "location", locations.sortBy("name").get("firstObject")
    seminar

  beforeModel: (transition) ->
    setTimeout (->
      if App.Session.authUser == undefined || App.Session.authUser.get("can_create_seminars") == false
        Flash.NM.push 'You are not authorized to access this page', "danger"
        window.history.go(-1)
    ), 500

  setupController: (controller, model) ->
    @_super controller, model
    controller.set 'pageTitle', "Create a seminar"

    if @controllerFor('locations').get("model").length == 0
      @controllerFor('locations').set "model", @store.find "location" # do not set "content"
    @controllerFor('locations').set "sortProperties", ["name"]
    @controllerFor('locations').set "sortAscending", true

    if @controllerFor('hosts').get("model").length == 0
      @controllerFor('hosts').set "model", @store.find "host" # do not set "content"
    @controllerFor('hosts').set "sortProperties", ["name"]
    @controllerFor('hosts').set "sortAscending", true
