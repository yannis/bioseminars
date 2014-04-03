App.SeminarSerializer = App.ApplicationSerializer.extend DS.EmbeddedRecordsMixin,
  attrs:
    categorisations:
      embedded: 'always'
    hostings:
      embedded: 'always'
