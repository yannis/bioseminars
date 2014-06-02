App.Host = DS.Model.extend
  name: DS.attr('string')
  text: Em.computed.alias('name') # for select2 component
  locked: false # for select2 component
  email: DS.attr('string')
  hostings: DS.hasMany('hosting')
  # seminars: DS.hasMany('seminar', { async: true })

  readable: DS.attr('boolean', {readOnly: true})
  updatable: DS.attr('boolean', {readOnly: true})
  destroyable: DS.attr('boolean', {readOnly: true})

  mailto: (->
    "mailto:" + @get("email")
  ).property("email")

  updatable_or_destroyable: (->
    @get("updatable") || @get("destroyable")
  ).property("updatable", "destroyable")
