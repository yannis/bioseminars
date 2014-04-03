Ember.Application.initializer
  name: 'session'

  initialize: (container, application) ->
    store = container.lookup('store:main')
    App.Session = Ember.Object.extend(
      init: () ->
        @_super()
        self = @
        currentTime = new Date()
        @set('year', currentTime.getFullYear())
        if $.cookie('authToken') && $.cookie('authUserId')
          user = store.find("user",
            authentication_token: $.cookie('authToken')
            user_id: $.cookie('authUserId')
          ).then (user) ->
            content = user.get('content')
            if content.length == 1
              self.set 'authToken', $.cookie('authToken')
              self.set 'authUserId', $.cookie('authUserId')
              self.set 'authUser', user.get('firstObject')

      authTokenChanged: (->
        authToken = @get('authToken')
        # console.log "authTokenChanged", authToken
        if authToken
          $.cookie('authToken', authToken)
        else
          $.removeCookie('authToken')
          $.removeCookie('_bioseminars_session')
          App.reset()
      ).observes('authToken')

      authUserIdChanged: (->
        authUserId = @get('authUserId')
        # console.log "authUserIdChanged", authUserId
        if authUserId
          $.cookie('authUserId', authUserId)
        else
          $.removeCookie('authUserId')
      ).observes('authUserId')
    ).create()
