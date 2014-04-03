App.Location = DS.Model.extend
  name: DS.attr('string')
  # description: DS.attr('string')
  building: DS.belongsTo('building')
  seminars: DS.hasMany({ async: true })

  readable: DS.attr('boolean', {readOnly: true})
  updatable: DS.attr('boolean', {readOnly: true})
  destroyable: DS.attr('boolean', {readOnly: true})

  name_and_building: (->
    "#{@get('name')} (#{@get('building.name')})"
  ).property('name', 'building.name')

  updatable_or_destroyable: (->
    @get("updatable") || @get("destroyable")
  ).property("updatable", "destroyable").readOnly()
