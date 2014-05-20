Em.Application.initializer
  name: 'internal_seminars'

  initialize: (container, application) ->
    App.Internal = Em.Object.extend(
      init: () ->
        @_super()

        @set 'show', $.cookie('show_internal_seminars') == 'true'

      showStatusChanged: (->
        $.cookie 'show_internal_seminars', @get('show')
      ).observes('show')
    ).create()
