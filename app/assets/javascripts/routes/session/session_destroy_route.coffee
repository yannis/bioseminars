# App.SessionDestroyRoute = Em.Route.extend
#   enter: ->
#     controller = @controllerFor 'currentUser'
#     controller.set 'content', undefined

#     App.Session.find('current').then (session) ->
#       session.deleteRecord()
#       controller.store.commit()
#     controller.transitionToRoute('index')


App.SessionDestroyRoute = Ember.Route.extend
  renderTemplate: (controller, model) ->
    controller.logout()
