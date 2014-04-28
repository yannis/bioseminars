App.CategoryView = Ember.View.extend
  templateName: 'categories/category'
  didInsertElement: ->
    Utilities.affixPanel.set()
