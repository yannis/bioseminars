App.UsersUserRoute = Ember.Route.extend Ember.SimpleAuth.AuthenticatedRouteMixin,

  model: (params)->
    @store.find("user", params.user_id).then(
      null,
      ((error) =>
        Flash.NM.push JSON.parse(error.responseText)["errors"], "danger"
        @goBackOr '/'
      )
    )

  afterModel: (model, transition) ->
    unless model? && model.get('readable')
      Flash.NM.push 'You are not authorized to access this page', "info"
      @goBackOr '/'

