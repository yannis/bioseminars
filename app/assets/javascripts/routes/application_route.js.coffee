App.ApplicationRoute = Em.Route.extend Em.SimpleAuth.ApplicationRouteMixin,

  actions:
    openModal: (resources, action, model) ->
      controllerName = "#{resources}_#{action}"
      modalName = "#{resources}/#{action}"
      @controllerFor(controllerName).set('model', model)
      @render modalName,
        into: 'application'
        outlet: 'modal'
      $('#app-modal').on "click", (e)=>
        if $(e.target).parents(".modal-dialog").length == 0
          e.preventDefault()
          e.stopPropagation()
          @send "cancelModal", model

    cancelModal: (model)->
      model.rollback()
      @send "closeModal"

    closeModal: ->
      $("#app-modal").modal 'hide'
      $('#app-modal').on 'hidden.bs.modal', (e) =>
        @disconnectOutlet
          outlet: 'modal'
          parentView: 'application'

    sessionAuthenticationSucceeded: ->
      @_super()
      Flash.NM.push 'Successfully signed in', 'success'

    sessionAuthenticationFailed: ->
      Flash.NM.push 'Invalid email or password', 'danger'

    sessionInvalidationSucceeded: ->
      @_super()
      Flash.NM.push 'Successfully signed out', 'success'
