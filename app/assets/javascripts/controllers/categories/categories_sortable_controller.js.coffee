App.CategorySortableView = Ember.View.extend
  tagName: 'tr'
  templateName: 'categories/sortable'
  # didInsertElement: ->
  #   debugger
  #   controller = @get("controller")
  #   $("ul.categories").sortable
  #     axis: "y"
  #     containment: "parent"
  #     items: "> li"
  #     handle: ".category-sortable-handle"
  #     cursor: "move"
  #     update: (event, ui) ->
  #       # console.log "event", event
  #       # console.log "ui", ui
  #       ids = ui.item.parent('ul').find('li').map ->
  #         # console.log ""
  #         $(@).data('id')
  #       # console.log "ids", ids
  #       # cats = []
  #       controller.send "sortModel", ids

  #       # for cat, i in controller.get("content")
  #       #   # index = i
  #       #   console.log "cat", cat.get("id")
  #       #   console.log "i", i
  #         # cat = controller.store.find("category", id).then (cat) ->
  #         #   # debugger
  #         #   cat.set('position', index+1)
  #         #   # cats.push cat
  #         #   cat.save()
  #       # console.log "cats", cats
  #       # cats.invoke("save")
