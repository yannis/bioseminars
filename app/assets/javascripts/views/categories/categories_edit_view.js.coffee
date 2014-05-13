App.CategoriesEditView = Ember.View.extend
  tagName: 'form'
  classNames: ['form-horizontal']

  willInsertElement: ->
    unless @get('controller.updatable')
      window.history.go(-1)
