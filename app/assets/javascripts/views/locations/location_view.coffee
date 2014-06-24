App.LocationView = Ember.View.extend
  templateName: 'locations/location'
  didInsertElement: ->
    Utilities.affixPanel.set()
