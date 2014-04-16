App.CategoriesNewController = Ember.ObjectController.extend App.ValidationErrorsMixin,
  pageTitle: "New category"
  actions:
    create: (category) ->
      if App.Session.authUser == undefined || App.Session.authUser.get("can_create_categories") == false
        category.deleteRecord()
        Flash.NM.push 'You are not authorized to access this page', "danger"
      else
        self = @
        category.set "archivedAt", moment(category.get('archivedAt')).toDate()
        category.save().then(
          (->
            Flash.NM.push 'Category successfully created', "success"
            self.transitionToRoute 'categories'
          ),
          ((error) ->
            self.setValidationErrors error.message
          )
        )

    cancel: (category) ->
      category.deleteRecord() if category
      @transitionToRoute 'categories'
