App.UsersUserRoute = Ember.Route.extend
  model: (params) ->
    @store.find("user", params.user_id).then(
      null,
      ((error) ->
        Flash.NM.push JSON.parse(error.responseText)["message"], "danger"
        window.history.go(-1)
      )
    )

  # beforeModel: (transition, params) ->
  #   if App.Session.authUser == undefined || (App.Session.authUser.get("content.admin") == false && App.Session.authUser.get("content.admin") != params.user_id)
  #     Flash.NM.push 'You are not authorized to access this page', "danger"
  #     window.history.go(-1)

  afterModel: (model, transition) ->
    unless model.get('readable')
      Flash.NM.push 'You are not authorized to access this page', "danger"
      window.history.go(-1)
