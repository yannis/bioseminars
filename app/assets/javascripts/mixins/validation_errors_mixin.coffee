App.ValidationErrorsMixin = Ember.Mixin.create
  validationErrors: null
  setValidationErrors: (error) ->
    errorArray = []
    $.each error.errors, (attribute, messages)->
      messages.every (message) ->
        errorArray.push "#{attribute} #{message}"
    @set 'validationErrors', errorArray
