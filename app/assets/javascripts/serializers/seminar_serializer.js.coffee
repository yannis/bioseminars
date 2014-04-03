App.SeminarSerializer = App.ApplicationSerializer.extend DS.EmbeddedMixin,
  attrs:
    categorisations:
      embedded: 'always'
    hostings:
      embedded: 'always'
