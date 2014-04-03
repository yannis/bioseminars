App.CategoryController = Ember.ObjectController.extend
  actions:
    destroy: (category) ->
      self = @
      if category.get("destroyable")
        if confirm "Are you sure to destroy category “#{category.name}”?"
          category.deleteRecord()
          category.save().then(
            (->
              self.transitionToRoute 'categories'
              Flash.NM.push 'Category successfully destroyed', "success"
            ),
            ((error)->
              category.rollback()
              Flash.NM.push "An error occured: #{error}", "danger"
            )
          )
      else
        Flash.NM.push "You can't destroy this category", "danger"

    close: ->
      this.transitionToRoute('categories')
