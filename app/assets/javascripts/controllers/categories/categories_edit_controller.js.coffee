App.CategoriesEditController = Ember.ObjectController.extend
  pageTitle: "Edit category"

  actions:
    update: (category) ->
      self = @
      category.set "archivedAt", moment(category.get('archivedAt')).toDate()
      category.save().then(
        (->
          Flash.NM.push 'Category successfully updated', "success"
          history.go -1
        ),
        ((error) ->
          if error.responseText.length
            Flash.NM.push JSON.parse(error.responseText)["message"], "danger"
          else
            self.setValidationErrors error.message
        )
      )

    cancel: (category) ->
      category.rollback()
      history.go -1
