App.BuildingView = Ember.View.extend
  templateName: 'buildings/building'
  didInsertElement: ->
    Utilities.affixPanel.set()
