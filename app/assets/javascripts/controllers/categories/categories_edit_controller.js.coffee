App.CategoriesEditController = Ember.ObjectController.extend

  pageTitle: (->
    "Edit category “#{@get('model.name')}”"
  ).property("model.name")

  actions:
    update: (category) ->
      self = @
      category.set "archivedAt", moment(category.get('archivedAt')).toDate()
      category.save().then(
        (->
          Flash.NM.push 'Category successfully updated', "success"
          self.send('closeModal')
        ),
        ((error) ->
          if error.responseText.length
            Flash.NM.push JSON.parse(error.responseText)["message"], "danger"
          else
            self.setValidationErrors error.message
        )
      )
