window.Utilities ||= {}
window.Utilities.affixPanel =
  set: ->
    $('.panel.panel-info').affix
      offset:
        top: 100
        bottom: ->
          @bottom = $('#footer').outerHeight(true)

# Ember.View.reopen
#   didInsertElement: ->
#     @_super()
#     Utilities.affixPanel.set()
