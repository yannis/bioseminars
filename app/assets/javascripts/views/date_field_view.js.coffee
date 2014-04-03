App.DateField = Em.TextField.extend
  didInsertElement: ->
    self = @
    if @get 'value'
      $(@$()[0]).val moment(@get 'value').format('YYYYMMDD')
    onChangeDate = (ev) =>
      self.set("value", ev.date) if ev && ev.date
    $(@$()[0]).parent("div").datetimepicker(
      pickTime: false
      format: 'YYYYMMDD'
      weekStart: 1
      todayBtn: "linked"
      todayHighlight: true
      keyboardNavigation: true
      startDate: '-1y'
      endDate: '+2y'
      autoclose: true
      forceParse: true
      time: false
    ).on 'changeDate', onChangeDate()
