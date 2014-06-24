App.CategoriesNewController = Ember.ObjectController.extend App.ValidationErrorsMixin,
  pageTitle: "New category"
  actions:
    create: (category) ->
      if @session? && @session.get("user.can_create_categories") == false
        building.rollback()
        Flash.NM.push 'You are not authorized to access this page', "info"
      else
        self = @
        category.set "archivedAt", moment(category.get('archivedAt')).toDate()
        category.save().then(
          (->
            Flash.NM.push 'Category successfully created', "success"
            self.send "closeModal"
          ),
          ((error) ->
            self.setValidationErrors error
          )
        )
