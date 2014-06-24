Em.Application.initializer
  name: 'route'

  initialize: (container, application) ->
    Em.Route.reopen
      goBackOr: (route)->
        if document.referrer == ""
          @transitionTo route
        else
          window.history.go(-2)
