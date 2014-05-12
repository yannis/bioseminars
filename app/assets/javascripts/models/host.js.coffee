App.Host = DS.Model.extend
  name: DS.attr('string')
  email: DS.attr('string')
  hostings: DS.hasMany('hosting')
  seminars: DS.hasMany({ async: true })

  readable: DS.attr('boolean')
  updatable: DS.attr('boolean')
  destroyable: DS.attr('boolean')

  mailto: (->
    "mailto:" + @get("email")
  ).property("email")

  updatable_or_destroyable: (->
    @get("updatable") || @get("destroyable")
  ).property("updatable", "destroyable")
