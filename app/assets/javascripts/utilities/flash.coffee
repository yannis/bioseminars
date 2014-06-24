# A view that displays notification (messages).
# Currently a single notification is displayed as an Alert on top of the screen, each notification in a time.

window.Flash = {}
Flash.NotificationsView = Ember.CollectionView.extend
  classNames: ['notifications']
  attributeBindings: ['style']
  contentBinding: 'Flash.NM.content'
  showTime: 2000
  fadeInTime: 500
  fadeOutTime: 3000
  showTimeTimeoutId: null
  # /*
  # itemViewClass: Flash.BsAlertComponent.extend(
  #     messageBinding: 'content.message'
  #     typeBinding: 'content.type'
  #     fadeInTimeBinding: 'parentView.fadeInTime'
  #     isVisible: false

  #     didInsertElement: ->
  #         @$().fadeIn(@get('fadeInTime'))
  # )
  # */

  itemViewClass: Ember.View.extend
    classNames: ['alert', 'notification']
    template: Ember.Handlebars.compile('{{view.content.message}}')
    classNameBindings: ["alertType"]
    isVisible: false
    alertType: (->
      return @get('content').get('classType')
    ).property('content')
    didInsertElement: (->
      @$().fadeIn(@get('fadeInTime'))
    )

  contentChanged: (->
    if @get('content').length > 0 then @resetShowTime()
  ).observes('content.length')

  resetShowTime: ->
    @$().css
      display: 'block'
    if @$().is(":animated")
      @$().stop().animate
        opacity: "100"
    if @showTimeTimeoutId != null then clearTimeout(@showTimeTimeoutId)
    @showTimeTimeoutId = setTimeout(@fadeOut, @showTime, this)

  fadeOut: (that) ->
    that.$().fadeOut that.fadeOutTime, ->
      that.get('content').clear()

  mouseEnter: ->
    if @$().is(":animated")
      @$().stop().animate
        opacity: "100"

  mouseLeave: ->
    @resetShowTime()

Ember.Handlebars.helper('bs-notifications', Flash.NotificationsView)

Flash.NM = Flash.NotificationManager = Ember.Object.create
  content: Ember.A()
  push: (message, type) ->
    type = (if type != null then type else type = 'info')
    notif = Flash.Notification.create
      message: message
      type: type
    @get('content').pushObject(notif)

# This object represents a notification to be displayed.
# Notification(s) are added into the NotificationQueue by the pushNotification function.

Flash.Notification = Ember.Object.extend
  classType: (->
    if @type != null then "alert-" + @type else null
  ).property('type').cacheable()
