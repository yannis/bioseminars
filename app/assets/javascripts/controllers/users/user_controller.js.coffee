App.UsersUserController = Ember.ObjectController.extend
  pageTitle: "All users"

  actions:

    destroy: (user) ->
      self = @
      if user.get("destroyable")
        bootbox.confirm "Are you sure to destroy host “#{user.get("name")}”?", (result) ->
          if result
            user.deleteRecord()
            user.save().then(
              (->
                self.transitionToRoute 'categories'
                Flash.NM.push 'User successfully destroyed', "success"
              ),
              ((error)->
                user.rollback()
                Flash.NM.push "An error occured: #{error}", "danger"
              )
            )
      else
        Flash.NM.push "You can't destroy this user", "danger"

    close: ->
        window.history.go(-1)
