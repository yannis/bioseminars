App.CategoriesNewRoute = Ember.Route.extend
  model: (params) ->
    cat = @store.createRecord "category", color: "#999999"
    console.log 'cat.get("defaultPosition")', cat.get("defaultPosition")
    cat.set("position", cat.get("defaultPosition"))
    cat
  afterModel: (model, transition) ->
    if App.Session.authUser == undefined || App.Session.authUser.get("can_create_categories") == false
      model.deleteRecord()
      Flash.NM.push 'You are not authorized to access this page', "danger"
      window.history.go(-1)

  setupController: (controller, model) ->
    @_super controller, model
    controller.set 'pageTitle', "New category"
