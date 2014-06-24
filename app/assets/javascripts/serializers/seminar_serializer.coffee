App.SeminarSerializer = App.ApplicationSerializer.extend DS.EmbeddedRecordsMixin,
  # attrs:
  #   categories:
  #     embedded: 'always'
  #   hosts:
  #     embedded: 'always'

  serialize: (model, options) ->
    json = @_super(model, options)
    json.host_ids = model.get("hosts").mapProperty('id')
    json.category_ids = model.get("categories").mapProperty('id')
    json
