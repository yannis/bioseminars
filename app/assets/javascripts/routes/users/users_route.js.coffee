App.UsersRoute = Ember.Route.extend
  model: ->
    @store.find("user").then(
      null,
      ((error) =>
        @transitionTo "/"
        Flash.NM.push JSON.parse(error.responseText)["message"], "danger"
      )
    )

  # beforeModel: (transition) ->
  #   if App.Session.authUser == undefined || !App.Session.authUser.get("content.admin") == false
  #     Flash.NM.push 'You are not authorized to access this page', "danger"
  #     window.history.go(-1)

  setupController: (controller, model) ->
    console.log "controller", controller
    @_super controller, model
    title = "All users"
    controller.set 'pageTitle', title
    document.title = title
