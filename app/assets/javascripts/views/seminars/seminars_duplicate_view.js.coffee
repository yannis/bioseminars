App.SeminarsDuplicateView = Ember.View.extend
  templateName: 'seminars/duplicate'
  FormSpeakersView: Ember.View.extend
    templateName: 'seminars/form_speakers'
  FormHostsView: Ember.View.extend
    templateName: 'seminars/form_hosts'


  sortLists: (->
    @controller.get("selectCategories").sortBy('position')
  ).observes('controller.selectCategories')


