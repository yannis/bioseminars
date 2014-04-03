App.SeminarsNextController = Ember.ArrayController.extend App.CategoriesSelectionControllerMixin, App.LoadSeminarsControllerMixin,

  pageTitle: "Next seminars"
  sortProperties: ['startAt']
  sortAscending: true

  actions:
    createSeminar: (name, description) ->
      App.Seminar.createRecord(title: title, description: description)
      @get('store').commit()
