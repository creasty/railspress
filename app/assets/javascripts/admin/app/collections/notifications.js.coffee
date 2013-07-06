
define [
  'underscore'
  'backbone'
  'backbone.pageable'
  'app/models/notification'
], (_, Backbone, PageableCollection, Notification) ->

  class NotificationsCollection extends PageableCollection

    model: Notification

    url: '/admin/notifications.json'
    mode: 'infinite'

    state:
      currentPage: 1
      pageSize: 10

    queryParams:
      unreadCount: 'unread'
      totalPages: null
      totalRecords: null

    unread: ->
      @filter (notification) -> !notification.get 'read'

    unreadCount: -> @state.unreadCount

  new NotificationsCollection()
