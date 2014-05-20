Em.Application.initializer
  name: 'route'

  initialize: (container, application) ->
    Em.Route.reopen
      goBackOr: (route)->
        @transitionTo route
