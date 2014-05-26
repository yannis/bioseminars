App.CategoriesView = Ember.View.extend
  templateName: 'categories/categories'

  didInsertElement: ->
    controller = @get("controller")
    if controller.get("session.user.admin")
      $("ul.categories-categories").sortable
        axis: "y"
        containment: "parent"
        items: "> li"
        # handle: ".category-sortable-handle"
        cursor: "move"
        update: ->
          controller.send "sortModel", $(@).sortable("toArray", {attribute: "data-id"})
