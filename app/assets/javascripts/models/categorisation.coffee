App.Categorisation = DS.Model.extend
  category: DS.belongsTo('category')
  seminar: DS.belongsTo('seminar')
  category_name: (->
    @get('category.name')
  ).property('category.name')
  relationshipsLoaded: ( ->
    @get('category.isLoaded') and @get('seminar.isLoaded')
  ).property 'category.isLoaded', 'seminar.isLoaded'
