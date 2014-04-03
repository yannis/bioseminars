App.Category = DS.Model.extend
  name: DS.attr('string')
  description: DS.attr('string')
  color: DS.attr('string')
  acronym: DS.attr('string')
  position: DS.attr('number')
  seminars: DS.hasMany('seminar', { async: true })

  readable: DS.attr('boolean', {readOnly: true})
  updatable: DS.attr('boolean', {readOnly: true})
  destroyable: DS.attr('boolean', {readOnly: true})
  updatable_or_destroyable: (->
    @get("updatable") || @get("destroyable")
  ).property("updatable", "destroyable").readOnly()

  acronym_or_name: (->
    if @get('acronym') then @get('acronym') else @get('name')
  ).property('acronym', 'name')

  colorStyle: (->
    return "background-color: #{@get('color')}"
  ).property('color')

  showMe: (->
    # debugger
    if $.cookie('categories_to_show')
      ids = JSON.parse($.cookie('categories_to_show'))
      id = @get('id')
      return id in ids
    else
      @store.find("category").then (categories)->
        ids = categories.mapBy("id")
        $.cookie( 'categories_to_show', JSON.stringify(ids), { expires: 365, path: '/' })
      true
  ).property('id')

  setShowMe: (->
    ids = JSON.parse($.cookie('categories_to_show'))
    # id = parseInt(@get('id'))
    id = @get('id')
    if @get('showMe') == true
      ids.push(id)
    else
      indx = ids.indexOf id
      ids.splice(indx, 1)
    $.cookie 'categories_to_show', JSON.stringify(ids.uniq()), { expires: 365, path: '/' }
  ).observes('showMe')

  colorStyle: (->
    "background-color: #{@get('color')}"
  ).property('color')
