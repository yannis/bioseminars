App.ValidationErrorsMixin = Ember.Mixin.create
  validationErrors: null
  setValidationErrors: (message) ->
    extracted_message = message.match(/{(.*)}/)[1]
    @set 'validationErrors', extracted_message
