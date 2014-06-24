App.Hosting = DS.Model.extend
  seminar: DS.belongsTo('seminar')
  host: DS.belongsTo('host')
  host_name: (->
    @get('host.name')
  ).property('host.name')
  host_email: (->
    @get('host.email')
  ).property('host.email')
