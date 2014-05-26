App.CategoryController = Ember.ObjectController.extend App.CategoriesSelectionControllerMixin,

  needs: ["categories"]

  seminarSorting: ["startAt:desc"]
  sortedSeminars: Ember.computed.sort("seminars", 'seminarSorting')

  latestSeminars: (->
    @get("sortedSeminars").filter (seminar) =>
      @get("sortedSeminars").indexOf(seminar) < 10
  ).property("seminars")

  actions:
    destroy: (category) ->
      self = @
      if category.get("destroyable")
        bootbox.confirm "Are you sure to destroy category “#{category.get("name")}”?", (result) ->
          if result
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

    setArchivedAt: (category)->
      if category.get("archivedAt")?
        category.set "archivedAt", null
        message = 'Category successfully unarchived'
      else
        category.set "archivedAt", moment().toDate()
        # debugger
        category.set "position", @get("controllers.categories.lastObject.position")+1
        message = 'Category successfully archived'
      category.save().then(
        (->
          Flash.NM.push message, "success"
        ),
        ((error) ->
          self.setValidationErrors error
        )
      )
