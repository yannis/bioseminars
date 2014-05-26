App.UsersRoute = Ember.Route.extend Ember.SimpleAuth.AuthenticatedRouteMixin,
  model: ->
    if @session.get("user.admin") == true
      @store.find("user")
    else
      Flash.NM.push "You are not authorized to access this page", "danger"
      window.history.go(-1)

  setupController: (controller, model) ->
    @_super controller, model
    title = "All users"
    controller.set 'pageTitle', title
    document.title = title
