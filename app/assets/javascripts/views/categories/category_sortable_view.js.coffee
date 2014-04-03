App.CategorySortableView = Ember.View.extend
  tagName: 'tr'
  templateName: 'categories/sortable'
  didInsertElement: ->
    # debugger
    controller = @get("controller")
    $("ul.categories-categories").sortable
      axis: "y"
      containment: "parent"
      items: "> li"
      handle: ".category-sortable-handle"
      cursor: "move"
      update: ->
        controller.send "sortModel", $(@).sortable("toArray", {attribute: "data-id"})
