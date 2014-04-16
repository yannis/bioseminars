#= require jquery
#= require jquery_ujs
#= require jquery.ui.sortable
#= require jquery.ui.effect
#= require beta_notifications
#= require handlebars
#= require ember
#= require ember-data

#= require_tree './utilities/'
#= require_self
#= require bioseminars

Em.LOG_BINDINGS = true
# Ember.RSVP.configure 'onerror', (e) ->
#   console.log(e.message) if e.message
#   console.log(e.stack) if e.stack

window.App = Em.Application.create
  LOG_TRANSITIONS: true
  title: 'bioSeminars'
  loading: false

