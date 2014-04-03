App.CalendarCategoryView = Ember.View.extend
  tagName: 'tr'

  classNames: ['calendar-category']

  templateName: 'calendar/calendar_category'

  # didInsertElement: ->
  #   $("table#categories tbody").sortable
  #     update: (event, ui) ->
  #       ids = ui.item.parent('tbody').find('td:first-of-type').map -> $(@).data('id')
  #       position = 1
  #       for id in ids
  #         cat = App.Category.find(id)
  #         cat.set('position', position)
  #         cat.get('transaction').commit()
  #         position += 1
