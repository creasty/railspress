define [
  'jquery'
  'filght/component'
], ($, defineComponent) ->

  defineComponent ->
    @defaultAttrs
      threshold: 15
      height: 25
      duration: 300
      parent: '#globalheader'
      statusbar: '<div id="statusbar"></div>'
      showClass: 'show'

    class Notification
      constructor: ->
        @create()

      create: ->
        return if @$notifi

        @state = null
        @$notifi = $('<div></div>').css 'height', 0
        @$text = $('<span></span>').appendTo @$notifi
        @$close = $('<div class="close"></div>').appendTo @$notifi
        @$timestamp = $('<div class="timestamp"></div>').appendTo @$notifi

        @events()
        @

      events: ->
        @$close.on 'click', => @remove()

      animate: (params, complete, $t = @$notifi) ->
        $t
        .stop()
        .animate params,
          duration: config.duration
          complete: => complete?()

      update: (state) ->
        $(document).trigger 'statusbarUpdate', [state, @state]
        @state = state

      active: (state, message, icon) ->
        @create()

        @$text.text message
        @$timestamp.timeago new Date()

        $(document).trigger 'statusbarPrependElement',
          @$notifi
          .attr('class', state)
          .addClass("icon-#{icon} icon-large")

        @animate
          height: config.height
        , =>
          @update 'active'

      inactive: ->
        return unless @$notifi

        @update 'inactive'
        @animate
          height: 0
        , =>
          $(document).trigger 'statusbarAppend', @$notifi.height config.height

        setTimeout (=> @remove()), 12e4

      remove: ->
        return unless @$notifi

        $n = @$notifi
        @$notifi = null

        @animate
          opacity: 0
          left: '-100%'
        , =>
          @update 'none'
          $n.remove()
        , $n

      progress: (message, icon = 'clear') ->
        @active 'progress', message, icon

      success: (message, icon = 'check') ->
        @active 'success', message, icon
        setTimeout (=> @inactive()), 3e3

      fail: (message, icon = 'ban') ->
        @active 'fail', message, icon
        setTimeout (=> @inactive()), 4e3

    -> new Notification()

  defineComponent notify
