App.SeminarsNextView = Ember.View.extend
  templateName: 'seminars/next_seminars'

  didInsertElement: ->
    $("#loading").hide()
    $(window).bind "scroll", =>
      @didScroll()

  willDestroyElement: ->
    $(window).unbind "scroll"

  didScroll: ->
    if @isScrolledToBottom()
      @get('controller').send('getMore')
    # // handle the awesomeness of didScroll

  isScrolledToBottom: ->
    distanceToTop = $(document).height() - $(window).height()
    top = $(document).scrollTop()
    top == distanceToTop
