App.LoadingRoute = Ember.Route.extend
  activate: ->
    @_super()
    App.set "loading", true
  deactivate: ->
    @_super()
    App.set "loading", false
