window.Utilities ||= {}
window.Utilities.affixPanel =
  set: ->
    $affixElement = $('.affix')
    $affixElement.width($affixElement.parent().width()).affix
      offset:
        top: 100
        bottom: ->
          @bottom = $('#footer').outerHeight(true)
