# For more information see: http://emberjs.com/guides/routing/

App.Router.map ->

  @route 'about'

  @resource 'buildings', ->
    @resource 'building', {path: '/:building_id'}
    @route 'edit', {path: '/:building_id/edit'}
  @resource 'buildings.new', {path: '/buildings/new'}

  @resource 'calendar', {path: '/calendar/:type/:year/:month/:day'}, ->
    @resource 'calendar_seminar', {path: '/seminar/:seminar_id'}

  @resource 'categories'
  @resource 'category', {path: '/categories/:category_id'}
  @resource 'categories.new', {path: '/categories/new'}
  @resource 'categories.edit', {path: '/categories/:category_id/edit'}

  @route "feeds"
  @route 'feeds.documentation', {path: 'feeds/documentation'}

  @resource 'hosts', {path: '/hosts'}, ->
    @resource 'host', {path: '/:host_id'}
    @route 'edit', {path: '/:host_id/edit'}
  @resource 'hosts.new', {path: '/hosts/new'}
  @resource 'hosts.edit', {path: '/hosts/:host_id/edit'}

  @resource 'locations', ->
    @resource 'location', {path: '/:location_id'}
    @route 'edit', {path: '/:location_id/edit'}
  @resource 'locations.new', {path: '/locations/new'}

  @resource 'seminars'
  @resource 'seminar', {path: 'seminars/:seminar_id'}
  @resource 'seminars.new', {path: 'seminars/new'}
  @resource 'seminars.new_with_date', {path: 'seminars/new_with_date/:year/:month/:day'}
  @resource 'seminars.edit', {path: 'seminars/:seminar_id/edit'}
  @resource 'seminars.duplicate', {path: 'seminars/:seminar_id/duplicate'}
  @resource 'seminars.next', {path: 'seminars/next'}
  @resource 'seminars.past', {path: 'seminars/past'}

  @resource "iframe", {path: 'iframe/:category_ids'}

  @resource 'session', {path: 'sessions'}, ->
    @route 'new'
    @route 'destroy'

  @resource 'users'
  @resource 'users.user', {path: 'users/:user_id'}
  @route 'users.new', {path: 'users/new'}
  @route 'users.edit', {path: 'users/:user_id/edit'}
  @route "users.reset_password", {path: 'users/reset_password'}
  @route "users.new_password", {path: 'users/new_password/:token'}

