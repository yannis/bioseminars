App.CategoriesNewRoute = Ember.Route.extend Ember.SimpleAuth.AuthenticatedRouteMixin,

  beforeModel: (transition)->
    @_super(transition)
    if @session.isAuthenticated && @session.get("user.can_create_categories") != true
      Flash.NM.push 'You are not authorized to access this page', "info"
      @goBackOr 'login'

  model: (params) ->
    cat = @store.createRecord "category", color: "#999999"
    cat.set("position", cat.get("defaultPosition"))
    cat

  afterModel: (model, transition) ->
    @send 'openModal', 'categories', 'new', model
    transition.abort()
