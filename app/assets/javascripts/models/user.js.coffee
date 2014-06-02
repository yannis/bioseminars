App.User = DS.Model.extend

  name: DS.attr('string')
  email: DS.attr('string')
  admin: DS.attr('boolean')
  password: DS.attr('string')
  password_confirmation: DS.attr('string')
  seminars: DS.hasMany('seminar', { async: true })
  created_at_timestamp: DS.attr('number', {readOnly: true})

  can_create_buildings: DS.attr('boolean', {readOnly: true})
  can_create_categories: DS.attr('boolean', {readOnly: true})
  can_create_categorisations: DS.attr('boolean', {readOnly: true})
  can_create_documents: DS.attr('boolean', {readOnly: true})
  can_create_hostings: DS.attr('boolean', {readOnly: true})
  can_create_hosts: DS.attr('boolean', {readOnly: true})
  can_create_locations: DS.attr('boolean', {readOnly: true})
  can_create_seminars: DS.attr('boolean', {readOnly: true})
  can_create_speakers: DS.attr('boolean', {readOnly: true})
  can_create_users: DS.attr('boolean', {readOnly: true})

  readable: DS.attr('boolean', {readOnly: true})
  updatable: DS.attr('boolean', {readOnly: true})
  destroyable: DS.attr('boolean', {readOnly: true})

  updatable_or_destroyable: (->
    @get("updatable") || @get("destroyable")
  ).property("updatable", "destroyable").readOnly()
