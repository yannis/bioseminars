App.HostsController = Ember.ArrayController.extend
  sortProperties: ['name']
  sortAscending: true
  pageTitle: "All buildings"
  # createLocation: (name, description, building) ->
  #   App.Location.createRecord(name: name, description: description, building: building)
  #   @get('store').commit()
