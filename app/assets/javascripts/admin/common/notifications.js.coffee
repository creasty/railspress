
define [
  'jquery'
  'underscore'
  'backbone'
  'app/collections/notifications'
  'app/views/notifications/topic_view'

  'domReady!'
], (
  $
  _
  Backbone
  Notifications
  NotificationTopicView
) ->

  #  App View
  #-----------------------------------------------
  class NotificationsView extends Backbone.View

    el: '#notification'

    initialize: ->
      @listenTo Notifications, 'add', @addOne
      @listenTo Notifications, 'reset', @addAll
      @listenTo Notifications, 'change:read', @updateCount

      @$counter = $ '#usermenu span.notifications'

      @$parent = @$el.parent()
      @$ul = @$ '> ul'

      @$parent.on 'scroll', @loadMore.bind @

      Notifications.fetch
        success: =>
          @$counter.html @unread = Notifications.unreadCount()
          @loadMore()

    updateCount: ->
      @$counter.html --@unread

    addOne: (topic) ->
      view = new NotificationTopicView model: topic
      $el = view.render().$el
      @$ul.append $el

    addAll: (_, ob) ->
      Notifications.each @addOne, @
      Notifications.add ob.previousModels, at: 0, silent: true

    loadMore: (e) ->
      buffer = 100

      bottomOfViewport = @$parent.scrollTop() + @$parent.height()

      bottomOfCollectionView = @$parent.scrollTop() + @$ul.offset().top + @$ul.height() - buffer

      if Notifications.hasNext() && !@isLoading && bottomOfViewport > bottomOfCollectionView

        @isLoading = true

        Notifications.getNextPage
          remove: false
          update: true
          success: =>
            @isLoading = false


  #  Initialize
  #-----------------------------------------------
  new NotificationsView()
