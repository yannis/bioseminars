App.CategoriesEditView = Ember.View.extend
  didInsertElement: ->
    $("#app-modal").modal 'show'
  willDestroyElement: ->
    $("#app-modal").modal 'hide'

