App.DateTimeField = Em.TextField.extend

  # didInsertElement: ->
  #   @$().datepicker()
  # willDestroyElement: ->
  #   @$().datepicker('destroy')

  didInsertElement: ->
    # debugger
    self = @
    if @get 'value'
      $(@$()[0]).val moment(@get 'value').format('YYYY-MM-DD HH:mm')
    onChangeDate = (ev) =>
      # debugger
      # date = moment.utc(ev.date).format('LLL')
      self.set("value", ev.date) if ev && ev.date
    $(@$()[0]).datetimepicker(
      format: 'YYYY-MM-DD HH:mm'
      weekStart: 1
      todayBtn: "linked"
      todayHighlight: true
      keyboardNavigation: true
      startDate: '-1y'
      endDate: '+2y'
      autoclose: true
      minuteStep: 15
      forceParse: true
    ).on 'changeDate', onChangeDate()

  # didInsertElement: ->
  #   if @get 'value'
  #     @$('input').val moment.utc(@get 'value').format('LLL')
  #   onChangeDate = (ev) =>
  #     date = moment.utc(ev.date).format('LLL')
  #     @set "value", date
  #   @$('.datetimepicker').datetimepicker(format: 'dd/MM/yyyy', pickTime: false).on "changeDate", onChangeDate
