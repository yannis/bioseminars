App.SeminarsNewView = Ember.View.extend
  templateName: 'seminars/new'
  FormSpeakersView: Ember.View.extend
    templateName: 'seminars/form_speakers'
  FormHostsView: Ember.View.extend
    templateName: 'seminars/form_hosts'

  sortLists: (->
    @controller.get("selectCategories").sortBy('position')
  ).observes('controller.selectCategories')

  setTitle: (->
    title = @controller.get("model.title")
    newTitle = "Create a seminar"
    newTitle += (if title then " “#{@controller.get("model.title")}”" else "")
    @set("controller.pageTitle", newTitle)
  ).observes('controller.model.title')


  # didInsertElement: ->
  #   $('.datetimepicker').datetimepicker
  #     format: 'yyyy-mm-dd hh:ii'
  #     weekStart: 1
  #     todayBtn: "linked"
