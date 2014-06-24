# http://emberjs.com/guides/models/using-the-store/
# DS.RESTAdapter.configure "plurals",
#   category: "categories"

App.Store = DS.Store.extend
  # Override the default adapter with the `DS.ActiveModelAdapter` which
  # is built to work nicely with the ActiveModel::Serializers gem.

  adapter: DS.ActiveModelAdapter
  # adapter: '_ams'




# see https://github.com/emberjs/data/pull/303
# App.ApplicationSerializer = DS.RESTSerializer.extend
#   serializeAttribute: (record, json, key, attribute) ->
#     @_super(record, json, key, attribute) if !attribute.options.readOnly

App.ApplicationSerializer = DS.ActiveModelSerializer.extend
  serializeAttribute: (record, json, key, attribute) ->
    # console.log "record", record
    # console.log "key", key
    # console.log "json", json
    # console.log "attribute", attribute
    @_super(record, json, key, attribute) unless attribute.options && attribute.options.readOnly
