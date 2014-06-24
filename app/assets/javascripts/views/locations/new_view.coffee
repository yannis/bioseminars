App.LocationsNewView = Ember.View.extend
  didInsertElement: ->
    $("#app-modal").modal 'show'
  willDestroyElement: ->
    $("#app-modal").modal 'hide'



# App.LocationsNewView = Ember.View.extend
#   templateName: 'locations/new'
#   tagName: 'form'
#   title: "New location"
#   button_text: "Create"
