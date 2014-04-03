Em.FlashQueue = Ember.ArrayProxy.create
  content: []
  contentChanged: ->
    current = Em.FlashController.get("content")
    if current != @objectAt(0)
      Em.FlashController.set "content", @objectAt(0)

  pushFlash: (type, message) ->
    @pushObject Em.FlashMessage.create
      message: message
      type: type

Em.FlashQueue.addObserver 'length', ->
  @contentChanged()
