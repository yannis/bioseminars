App.CategoriesSelectionControllerMixin = Ember.Mixin.create

  needs: ['categories']

  showAll: false

  limitedCategories: (->
    cats = @get('controllers.categories')
    if @get('showAll')
      cats
    else
      cats.filter (model) =>
        cats.indexOf(model) < 10
  ).property('controllers.categories.model.length', 'showAll')

  actions:

    toggleShowMe: ->
      @get('controllers.categories').send('toggleShowMe')

    toggleShowAllCategories: ->
      @set('showAll', !@get('showAll'))



App.CategoriesSelectionRouteMixin = Ember.Mixin.create

  setupController: (controller, model) ->
    @_super controller, model
    if @controllerFor('categories').get("model").length == 0
      @controllerFor('categories').set "model", @store.find "category" # do not set "content"
    @controllerFor('categories').set "sortProperties", ["position"]
    @controllerFor('categories').set "sortAscending", true
