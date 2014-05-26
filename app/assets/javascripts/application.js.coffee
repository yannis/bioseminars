#= require jquery
#= require jquery_ujs
#= require jquery.ui.sortable
#= require jquery.ui.effect-highlight
#= require jquery.qtip
#= require beta_notifications
#= require handlebars
#= require ember
#= require ember-data
#= require "ember-simple-auth-0.4.0"
#= require "ember-simple-auth-devise-0.4.0"

#= require_tree './utilities/'
#= require_self
#= require bioseminars

@EmberENV =
  FEATURES:
    'query-params-new': true

Em.LOG_BINDINGS = true

window.App = Em.Application.create
  LOG_TRANSITIONS: true
  title: 'bioSeminars'
  loading: false

