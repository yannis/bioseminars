App.LoadSeminarsControllerMixin = Em.Mixin.create
  page: 1
  perPage: 10
  loadingMore: false
  noMoreSeminars: false

  # Also add a method `gotMore` that the route can call back to
  # notify the controller that the new data is in and it can stop
  # showing its loading indicator
  gotMore: (seminars, page) ->
    @set 'loadingMore', false
    if seminars.length == 0
      # console.log "no more seminaaaars", seminars
      @set 'noMoreSeminars', true
    else
      console.log "more seminaaaars", seminars
      @pushObjects(seminars)
      @set('content', @get('content').uniq()) # objects are pushed twice and I don't know why
      @set 'page', page

App.LoadSeminarsRouteMixin = Em.Mixin.create
  actions:
    getMore: ->
      controller = @get('controller')
      controller.set "loadingMore", true
      nextPage = controller.get('page') + 1
      @getSeminars(nextPage).then (seminars)->
        controller.gotMore(seminars.get("content"), nextPage)
