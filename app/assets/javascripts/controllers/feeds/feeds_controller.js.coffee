App.FeedsController = Ember.ArrayController.extend App.CategoriesSelectionControllerMixin,
  needs: ['categories']

  types: ["json", "atom", "rss", "xml", "ics"]
  selectedType: "json"
  internal: true
  asc: true
  scopes : ["all", "past", "future"]
  selectedScope: "future"
  after: null
  before: null
  limit: 20
  alarm: false
  alarmMinutes: 60

  askForAlarm: (->
    @get("selectedType") == "ics"
  ).property("selectedType")

  alarmDisabled: (->
    !@get('alarm')
  ).property('alarm')

  selectedCategories: (->
    @get("controllers.categories").filter (cat) =>
      cat.get("showMe") == true
  ).property("controllers.categories.@each.showMe")

  categoriesParam: (->
    categoryIds = @get('selectedCategories').sortBy('id').mapBy('id')
    "categories=#{categoryIds.join(",")}"
  ).property("selectedCategories")

  url: (->
    # debugger
    domain = document.domain
    model = "/api/v2/seminars"
    type = ".#{@get('selectedType')}"

    parameters = ["internal=#{@get('internal')}"]
    parameters.push "scope=#{@get('selectedScope')}" if @get('selectedScope')
    parameters.push "order=#{if @get('asc') then "asc" else "desc" }"
    parameters.push "after=#{moment(@get('after')).format("YYYYMMDD")}" if @get('after')
    parameters.push "before=#{moment(@get('before')).format("YYYYMMDD")}" if @get('before')
    parameters.push "limit=#{@get('limit')}" if @get('limit')
    parameters.push "alarm=#{@get('alarmMinutes')}" if @get('alarm') && (@get('alarmMinutes') >= 0) && @get("selectedType") == "ics"
    parameters.push @get('categoriesParam')
    parameters = parameters.join("&")

    url = [domain, model]
    # url = (if @get('selectedType') == 'ics' then "webcal://" else "http://")
    url = "http://"
    url += domain
    url += model
    url += type
    url += "?#{parameters}"
    url
  ).property("selectedType", "selectedScope", "asc", "after", "before", "internal", "limit", "categoriesParam", "alarm", "alarmMinutes")
