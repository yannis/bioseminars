App.SeminarsView = Ember.View.extend
  templateName: 'seminars/seminars'

  didInsertElement: ->
    $("#loading").hide()
    $(window).on "scroll", =>
      @didScroll()

  willDestroyElement: ->
    $(window).unbind "scroll"

  didScroll: ->
    if @isScrolledToBottom()
      @get('controller').send('getMore')# if @get('controller')

  isScrolledToBottom: ->
    distanceToTop = $(document).height() - $(window).height()
    top = $(document).scrollTop()
    top == distanceToTop
