App.SeminarsController = Ember.ArrayController.extend App.CategoriesSelectionControllerMixin, App.LoadSeminarsControllerMixin,

  pageTitle: "All seminars"
  sortProperties: ['startAt']
  sortAscending: false

  # actions:
  #   createSeminar: (name, description) ->
  #     App.Seminar.createRecord
  #       title: title
  #       description: description
  #     @get('store').commit()
