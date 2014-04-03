App.Publication = DS.Model.extend
  pubdate: DS.attr('string')
  title: DS.attr('string')
  affiliation: DS.attr('string')
  abstract: DS.attr('string')
  journal: DS.attr('string')
  issue: DS.attr('string')
  volume: DS.attr('string')
  pages: DS.attr('string')
  abstract: DS.attr('string')
  authors: DS.attr('string')
  fullDetails: (->
    console.log "@get('pubdate')", @get('pubdate')
    [@get('journal'), @get('volume'), @get('issue'), @get('pages'), @get('pubdate')].compact().join(", ")
  ).property('journal', 'volume', 'issue', 'pages', 'pubdate')

App.PublicationAdapter = DS.RESTAdapter.extend

  buildURL: (record, suffix) ->
    params =
      db: 'pubmed'
      apikey: '0d1b08c34858921bc7c662b228acb7ba'
      id: suffix
    "http://entrezajax.appspot.com/efetch?#{$.param(params)}"

  ajax: (url, type, hash={}) ->
    adapter = this

    return new Ember.RSVP.Promise (resolve, reject) ->
      hash = hash
      hash.url = url
      hash.type = type
      hash.dataType = 'jsonp'
      hash.context = adapter
      if (hash.data && type != 'GET')
        hash.contentType = 'application/json; charset=utf-8'
        hash.data = JSON.stringify(hash.data)

      hash.success = (data) ->
        if data['result'] && data['result'].length > 0
          params = @serializePublicationFromData data
          Ember.run(null, resolve, {publication: params})
        else if data['entrezajax'] && data['entrezajax']['error']
          console.log data['entrezajax']['error_message']
        else
          return

      hash.error = (jqXHR, textStatus, errorThrown) ->
        Ember.run(null, reject, jqXHR)

      Ember.$.ajax(hash)

  serializePublicationFromData: (data)->
    console.log "data", data
    result = data['result'][0]
    json = data['result'][0]['MedlineCitation']['Article']
    params = {pubdate: null}

    params['id'] = data['result'][0]['MedlineCitation']['PMID']
    params['title'] = json['ArticleTitle'] if json['ArticleTitle']
    params['affiliation'] = json['Affiliation'] if json['Affiliation']
    if json['Abstract'] && json['Abstract']['AbstractText'].length > 0
      params['abstract'] = json['Abstract']['AbstractText'][0]
    if json['Journal']
      params['journal'] = json['Journal']['ISOAbbreviation'] if json['Journal']['ISOAbbreviation']
      if json['Journal']['JournalIssue']
        params['issue'] = json['Journal']['JournalIssue']['Issue'] if json['Journal']['JournalIssue']['Issue']
        params['volume'] = json['Journal']['JournalIssue']['Volume'] if json['Journal']['JournalIssue']['Volume']
        if json['Journal']['JournalIssue']['PubDate']
          params['pubdate'] = [json['Journal']['JournalIssue']['PubDate']['Day'], json['Journal']['JournalIssue']['PubDate']['Month'], json['Journal']['JournalIssue']['PubDate']['Year']].compact().join(' ')
    params['pages'] = json['Pagination']['MedlinePgn'] if json['Pagination']['MedlinePgn']
    if json['AuthorList'] && json['AuthorList'].length > 0
      params['authors'] = json['AuthorList'].map((i) ->  "#{i['LastName']} #{i['Initials']}").join(', ')
    params

DS.PublicationSerializer = DS.RESTSerializer.extend
  rootForType: (type) ->
    return 'result'
  # primaryKey: 'id'


# App.Store.registerAdapter("App.Publication", App.publicationAdapter)
