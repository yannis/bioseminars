App.SeminarsController = Ember.ArrayController.extend App.CategoriesSelectionControllerMixin, App.LoadSeminarsControllerMixin,

  pageTitle: "All seminars"
  sortProperties: ['startAt']
  sortAscending: false
