App.ApplicationRoute = Em.Route.extend

  actions:
    openModal: (resources, action, model) ->
      $("#app-modal").modal 'hide'
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
