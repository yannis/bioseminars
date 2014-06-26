// Generated by CoffeeScript 1.7.1
App.ValidationErrorsMixin = Ember.Mixin.create({
  validationErrors: null,
  setValidationErrors: function(error) {
    debugger;
    var errorArray;
    errorArray = [];
    $.each(error.errors, function(attribute, messages) {
      return messages.every(function(message) {
        return errorArray.push("" + attribute + " " + message);
      });
    });
    return this.set('validationErrors', errorArray);
  }
});
