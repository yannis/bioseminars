# For more information see: http://emberjs.com/guides/routing/

App.Router.map ->
  @resource 'buildings', ->
    @route 'new'
    @resource 'building', {path: '/:building_id'}
    @route 'edit', {path: '/:building_id/edit'}

  @resource 'calendar', {path: '/calendar/:type/:year/:month/:day'}, ->
    @resource 'calendar_seminar', {path: '/seminar/:seminar_id'}

  @resource 'categories', ->
    @route 'new'
    @resource 'category', {path: '/:category_id'}, ->
    @route 'edit', {path: '/:category_id/edit'} # go to the route to see how I get the :category_id

  @route "feeds"
  @route 'feeds.documentation', {path: 'feeds/documentation'}

  @resource 'hosts', {path: '/hosts'}, ->
    @route 'new'
    @resource 'host', {path: '/:host_id'}
    @route 'edit', {path: '/:host_id/edit'}

  @resource 'locations', ->
    @route 'new'
    @resource 'location', {path: '/:location_id'}
    @route 'edit', {path: '/:location_id/edit'}

  @resource 'seminars', ->
  @resource 'seminar', {path: 'seminars/:seminar_id'}
  @route 'seminars.new', {path: 'seminars/new'}
  @resource 'seminars.edit', {path: 'seminars/:seminar_id/edit'}
  @resource 'seminars.duplicate', {path: 'seminars/:seminar_id/duplicate'}
  @resource 'seminars.next', {path: 'seminars/next'}
  @resource 'seminars.past', {path: 'seminars/past'}

  # @resource 'seminar', {path: '/seminars/:seminar_id'}
  # @resource 'seminar.edit', {path: '/seminars/:seminar_id/edit'}

  @resource 'session', {path: 'sessions'}, ->
    @route 'new'
    @route 'destroy'

  @resource 'users'
  @resource 'users.user', {path: 'users/:user_id'}
  @route 'users.new', {path: 'users/new'}
  @route 'users.edit', {path: 'users/:user_id/edit'}
  @route "users.reset_password", {path: 'users/reset_password'}
  @route "users.new_password", {path: 'users/new_password/:token'}

