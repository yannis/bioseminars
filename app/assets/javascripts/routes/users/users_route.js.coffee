App.UsersRoute = Ember.Route.extend
  model: ->
    if App.Session.authUser && App.Session.authUser.get("admin") == true
      @store.find("user")
    else
      Flash.NM.push "You are not authorized to access this page", "danger"
      window.history.go(-1)

  # beforeModel: (transition) ->
  #   if App.Session.authUser == undefined || !App.Session.authUser.get("content.admin") == false
  #     Flash.NM.push 'You are not authorized to access this page', "danger"
  #     window.history.go(-1)

  setupController: (controller, model) ->
    @_super controller, model
    title = "All users"
    controller.set 'pageTitle', title
    document.title = title
