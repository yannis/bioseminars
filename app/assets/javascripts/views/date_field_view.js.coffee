App.DateField = Em.TextField.extend
  date: null
  attributeBindings: ['value','format','readonly','type','size']
  size:"16"
  type: "text"
  format:'YYYY-MM-DD'
  value: ( ->
    if date = @get('date')
      date
    else
      ""
  ).property('date')
  didInsertElement: ->
    fmt = @get('format')
    onChangeDate = (ev) =>
      @set 'date', ev.date
    @.$().datetimepicker(
      format: fmt,
      autoclose: true
    ).on('changeDate', onChangeDate)

  willDestroyElement: -> @$().datetimepicker('remove')


  # didInsertElement: ->
  #   # debugger
  #   self = @
  #   if @get 'value'
  #     $(@$()[0]).val moment(@get 'value').format('YYYYMMDD')
  #   onChangeDate = (ev) =>
  #     debugger
  #     self.set("value", ev.date) if ev && ev.date
  #   $(@$()[0]).parent("div").datetimepicker(
  #     pickTime: false
  #     format: 'YYYY-MM-DD'
  #     weekStart: 1
  #     todayBtn: "linked"
  #     todayHighlight: true
  #     keyboardNavigation: true
  #     startDate: '-1y'
  #     endDate: '+2y'
  #     autoclose: true
  #     forceParse: true
  #     time: false
  #   ).on 'changeDate', onChangeDate()
