App.BuildingsNewRoute = Ember.Route.extend
  model: ->
    @store.createRecord "building"

  beforeModel: (transition) ->
    if App.Session.authUser == undefined || App.Session.authUser.get("can_create_buildings") == false
      Flash.NM.push 'You are not authorized to access this page', "danger"
      window.history.go(-1)
