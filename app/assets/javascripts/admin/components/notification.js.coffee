define [
  'jquery'
  'flight/lib/component'
], ($, defineComponent) ->

  defineComponent ->

    @defaultAttrs
      threshold: 15
      height: 25
      duration: 300
      parent: '#globalheader'
      showClass: 'show'

    @create = ->
      @state = null

      @$notifi = $('<div></div>').css 'height', 0
      @$text = $('<span></span>').appendTo @$notifi
      @$close = $('<div class="close"></div>').appendTo @$notifi
      @$timestamp = $('<div class="timestamp"></div>').appendTo @$notifi

    @animate = (params, complete) ->
      @$notifi
      .stop()
      .animate params,
        duration: config.duration
        complete: -> complete?()

    @update = (state) ->
      $(document).trigger 'statusbarUpdate', [state, @state]
      @state = state

    @active = (state, message, icon) ->
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

    @inactive = ->
      @update 'inactive'

      @animate
        height: 0
      , =>
        $(document).trigger 'statusbarAppend', @$notifi.height config.height

      clearTimeout @timer if @timer?
      @timer = setTimeout (=> @remove()), 12e4

    @remove = ->
      clearTimeout @timer if @timer?

      @animate
        opacity: 0
        left: '-100%'
      , =>
        @update 'none'

    @progress = (e, message, icon = 'clear') ->
      @active 'progress', message, icon

    @success = (e, message, icon = 'check') ->
      @active 'success', message, icon
      @timer = setTimeout (=> @inactive()), 3e3

    @fail = (e, message, icon = 'ban') ->
      @active 'fail', message, icon
      @timer = setTimeout (=> @inactive()), 4e3

    @after 'initialize', ->
      @create()
      @$close.on 'click', => @remove()

      @on 'notifyProgress', @progress
      @on 'notifySuccess', @success
      @on 'notifyFail', @fail


