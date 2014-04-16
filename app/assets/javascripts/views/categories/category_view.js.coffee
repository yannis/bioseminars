App.CategoryView = Ember.View.extend
  templateName: 'categories/category'
  # didInsertElement: ->
  #   s = $(@.get('element'))
  #   st = s.scrollTop();
  #   if st >= 240
  #     s.css({position:'absolute', top:'330px'})
  #   else
  #     s.css({position:'fixed', top:'100px'})

    # $scrollfollow   = $(@.get('element'))
    # $window    = $(window)
    # offset     = $scrollfollow.offset()
    # topPadding = 15
    # $window.scroll ->
    #   if $window.scrollTop() > offset.top
    #     $scrollfollow.stop().animate
    #       marginTop: $window.scrollTop() #- offset.top + topPadding
    #   else
    #     $scrollfollow.stop().animate
    #       marginTop: 0
