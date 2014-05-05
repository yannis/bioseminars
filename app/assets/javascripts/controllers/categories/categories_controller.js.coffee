App.CategoriesController = Ember.ArrayController.extend

  pageTitle: "All categories"

  sortProperties: ['archivedAt', 'position']
  sortAscending: true

  actions:
    createCategory: (name, description) ->
      App.Category.createRecord(name: name, description: description, color: color, acronym: acronym)
      @get('store').commit()

    toggleShowMe: ->
      @setEach 'showMe', !(@getEach('showMe').uniq().length == 1 && @getEach('showMe').uniq()[0] == true)

    sortModel: (ids) ->
      $.each ids, (i, id) =>
        category = @findBy("id", id)
        category.set("position", i+1)


      try
        @invoke("save")
        Flash.NM.push 'Categories successfully reordered', "success"
      catch e
        Flash.NM.push "Categories not reordered: #{e}", "danger"

