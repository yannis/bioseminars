App.BuildingsNewRoute = Ember.Route.extend

  model: ->
    @store.createRecord "building"

  afterModel: (model, transition) ->
    if App.Session.authUser == undefined || App.Session.authUser.get("can_create_buildings") == false
      model.rollback()
      Flash.NM.push 'You are not authorized to access this page', "danger"
      @goBackOr 'buildings'
    else
      @send 'openModal', 'buildings', 'new', model
      transition.abort()
