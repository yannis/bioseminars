App.LocationsNewRoute = Ember.Route.extend

  model: ->
    @store.createRecord "location"

  afterModel: (location, transition) ->
    if App.Session.authUser == undefined || App.Session.authUser.get("can_create_locations") == false
      location.deleteRecord()
      Flash.NM.push 'You are not authorized to access this page', "danger"
      @goBackOr 'locations'
    else
      @send 'openModal', 'locations', 'new', location
      @controllerFor('buildings').set('content', @store.find( "building"))
      @controllerFor('buildings').set "sortProperties", ["name"]
      @controllerFor('buildings').set "sortAscending", true
      transition.abort()
