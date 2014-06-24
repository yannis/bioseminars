App.LocationsController = Ember.ArrayController.extend
  pageTitle: "All locations"
  sortProperties: ['name']
  sortAscending: true
  # createLocation: (name, description, building) ->
  #   App.Location.createRecord(name: name, description: description, building: building)
  #   @get('store').commit()
