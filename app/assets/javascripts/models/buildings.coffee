App.Building = DS.Model.extend

  name: DS.attr('string')
  # locations: DS.hasMany('location')
  locations: DS.hasMany({ async: true })

  readable: DS.attr('boolean', {readOnly: true})
  updatable: DS.attr('boolean', {readOnly: true})
  destroyable: DS.attr('boolean', {readOnly: true})

  updatable_or_destroyable: (->
    @get("updatable") || @get("destroyable")
  ).property("updatable", "destroyable").readOnly()
