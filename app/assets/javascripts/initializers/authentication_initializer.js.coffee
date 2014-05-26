Ember.Application.initializer
  name: 'authentication'

  initialize: (container, application)->


    Ember.SimpleAuth.Authenticators.Devise.reopen
      serverSignOut: '/users/sign_out'

      invalidate: ->
        Ember.$.ajax
          url:  @serverSignOut
          type: 'DELETE'
          dataType:   'json'
          beforeSend: (xhr, settings)->
            xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').last().attr('content'))
            xhr.setRequestHeader('Accept', settings.accepts.json)

    Ember.SimpleAuth.Session.reopen
      user: (->
        userId = @get('user_id')
        if !Ember.isEmpty userId
          container.lookup('store:main').find('user', userId)
      ).property('userId')

    Ember.SimpleAuth.AuthenticatedRouteMixin.reopen
      beforeModel: (transition)->
        if !@session.isAuthenticated
          Flash.NM.push('You are not authorized to access this page', "info")
        @_super(transition)

    Ember.SimpleAuth.setup container, application,
      authorizerFactory: 'ember-simple-auth-authorizer:devise'
