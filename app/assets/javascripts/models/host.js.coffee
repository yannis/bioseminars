App.Host = DS.Model.extend
  name: DS.attr('string')
  email: DS.attr('string')
  hostings: DS.hasMany('hosting')

  readable: DS.attr('boolean')
  updatable: DS.attr('boolean')
  destroyable: DS.attr('boolean')

  updatable_or_destroyable: (->
    @get("updatable") || @get("destroyable")
  ).property("updatable", "destroyable")
