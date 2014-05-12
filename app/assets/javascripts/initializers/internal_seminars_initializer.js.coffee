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

  # initialize: (container, application) ->
  #   store = container.lookup('store:main')
  #   App.Session = Em.Object.extend(
  #     init: () ->
  #       @_super()
  #       self = @
  #       currentTime = new Date()
  #       @set('year', currentTime.getFullYear())
  #       if $.cookie('authToken') && $.cookie('authUserId')
  #         user = store.find("user",
  #           authentication_token: $.cookie('authToken')
  #           user_id: $.cookie('authUserId')
  #         ).then (user) ->
  #           theUser = user.get('firstObject')
  #           if user.get('content').length == 1
  #             self.set 'authToken', $.cookie('authToken')
  #             self.set 'authUserId', $.cookie('authUserId')
  #             self.set 'authUser', theUser

  #     authTokenChanged: (->
  #       authToken = @get('authToken')
  #       if authToken
  #         $.cookie('authToken', authToken)
  #       else
  #         $.removeCookie('authToken')
  #         $.removeCookie('_bioseminars_session')
  #         @set 'authToken', undefined
  #         @set 'authUserId', undefined
  #         @set 'authUser', undefined
  #         # App.reset()
  #     ).observes('authToken')

  #     authUserIdChanged: (->
  #       authUserId = @get('authUserId')
  #       if authUserId
  #         $.cookie('authUserId', authUserId)
  #       else
  #         $.removeCookie('authUserId')
  #     ).observes('authUserId')

  #   ).create()
