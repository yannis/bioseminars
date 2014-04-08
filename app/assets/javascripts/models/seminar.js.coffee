App.Seminar = DS.Model.extend
  title: DS.attr('string')
  description: DS.attr('string')
  url: DS.attr('string')
  title: DS.attr('string')
  speakerName: DS.attr('string')
  speakerAffiliation: DS.attr('string')
  pubmed_ids: DS.attr('string')
  internal: DS.attr('boolean')
  all_day: DS.attr('boolean')
  # start_at: DS.attr('date')
  startAt: DS.attr('date',
    defaultValue: ->
      moment().add('hours', 1).startOf('hours')
  )
  endAt: DS.attr('date')

  hosts: DS.hasMany('host')
  hostings: DS.hasMany('hosting')

  # categories: DS.hasMany('category')
  categorisations: DS.hasMany('categorisation')
  categories: ( ->
    @get('categorisations').getEach('category')
  ).property 'categorisations.@each.relationshipsLoaded'
  categorisations_attributes: ( ->
    @get('categorisations')
  ).property "categorisations"

  location: DS.belongsTo('location')

  readable: DS.attr('boolean', {readOnly: true})
  updatable: DS.attr('boolean', {readOnly: true})
  destroyable: DS.attr('boolean', {readOnly: true})

  updatable_or_destroyable: (->
    @get("updatable") || @get("destroyable")
  ).property("updatable", "destroyable")

  formatted_start: (->
    # return moment(@get('startAt')).format("MMM Do YYYY, HH:mm")
    return moment(@get('startAt')).format("DD-MM-YYYY HH:mm") if @get('startAt')
  ).property('startAt')

  formatted_end: (->
    return moment(@get('endAt')).format("DD-MM-YYYY HH:mm") if @get('endAt')
  ).property('endAt')

  acronyms: (->
    @get('categories').mapBy('acronym').join("; ")
  ).property('categories.@each.acronym')

  color: (->
    @get('categories').sortBy('position').mapBy('color')[0]
  ).property('categories.@each.color')

  colorStyle: (->
    "background-color: #{@get('color')}"
  ).property('color')


  date_time_location_and_category: (->
    [@get('formatted_start'), @get('location.name_and_building'), @get('acronyms')].join(" - ")
  ).property('formatted_start', 'location.name_and_building', 'category.acronyms')

  publications: (->
    publications = []
    pubMedIds = @get('pubmed_ids')
    # console.log "pubMedIds", pubMedIds
    if pubMedIds
      pubMedIds = pubMedIds.match(/\d+/g).unique()
      for pubMedId in pubMedIds
        @store.find("publication", pubMedId).then (publication)->
          # console.log "publication", publication
          publications.addObject publication
    return publications
  ).property('pubmed_ids')

  show: (->
    true in @get('categories').mapBy('showMe')
    # debugger
  ).property('categories.@each.showMe')

  hide: (->
    @get("show") == false
  ).property('show')

  icsUrl: (->
    "http://#{document.domain}/api/v2/seminars/#{@get('id')}.ics"
  ).property("id")

  asJSON: (->
    id: @get('id')
    # title: @get('display_title')
    title: @get('acronyms')
    start: moment(@get('startAt')).format("YYYY-MM-DD HH:mm")
    end: if @get('endAt') then moment(@get('endAt')).format("YYYY-MM-DD HH:mm") else null
    allDay: @get('all_day')
    color: @get('color')
    className: "fc-event-#{@get('id')} #{if @get('show') then '' else 'hidden'}"
    emSelf: @
  ).property('title', 'acronyms', 'startAt', 'endAt', 'allDay', 'color', 'showMe')

