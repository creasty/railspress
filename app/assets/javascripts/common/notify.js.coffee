###

- nc
  - active     <= notification == active
  - progress   <= notification == progress
  - total      <= notification != hidden

- notification
  - state
    - acitive: 1
    - inactive: 0
    - removed: -1

  - (style)
    - success
    - fail
    - progress

- statubar
  - mute    (display: 0)
  - active  (display: 1)
  - hover   (display: all)

---------------------------------

[nc.active > 1]
  statusbar -> active

[]

###

###
define ['jquery', 'common/timeago', 'domReady!'], ($) ->
  config =
    threshold: 15
    height: 25
    duration: 300


  Statusbar =
    mute: ->
    active: ->
    hover: ->

    events: ->

  NotifiCenter =
    count:
      acitive: 0
      progress: 0
      total: 0

    update: ->


  class Notification
    state: 0

    constructor: ->

    success: ->
    fail: ->
    progress: ->

###

define ['jquery', 'common/timeago', 'domReady!'], ($) ->
  S_HEIGHT = 15
  N_HEIGHT = 25
  ANIMATION = 300

  count = 0
  active_count = 0

  $statusbar = $('<div id="statusbar"></div>').appendTo $ '#globalheader'

  $statusbar.hover =>
    return if count < 1

    $statusbar
    .addClass('has-notifications')
    .stop()
    .animate
      opacity: 1
      height: count * N_HEIGHT
    ,
      duration: ANIMATION

  , =>
    $statusbar
    .animate
      opacity: 0
      height: S_HEIGHT
    ,
      duration: ANIMATION
      complete: ->
        $statusbar.removeClass('has-notifications')

  class Statusbar

    update: ->
      $statusbar
      .addClass('has-notifications')
      .height('auto')
      .stop()
      .animate
        opacity: 1
      ,
        duration: ANIMATION

    remove: ->
      return unless @$notification

      $n = @$notification
      --count
      @$notification = null

      $n.animate
        opacity: 0
        left: '-100%'
      ,
        duration: ANIMATION
        complete: =>
          $n.remove()
          $statusbar.removeClass 'has-notifications' if count == 0

    hide: ->
      return unless @$notification

      @$notification
      .animate
        height: 0
      ,
        duration: ANIMATION
        complete: =>
          @$notification.height(N_HEIGHT).appendTo $statusbar
          --active_count
          @update()

      setTimeout (=> @remove()), 12e4

    create: ->
      return if @$notification
      ++count

      @$notification = $ '<div></div>'
      @$text = $('<span></span>').appendTo @$notification
      @$close = $('<div class="close"></div>').appendTo @$notification
      @$timestamp = $('<div class="timestamp"></div>').appendTo @$notification

      @events()
      @

    events: ->
      @$close.on 'click', => @remove()

    show: (state, message, icon) ->
      @create()

      @$text.text message
      @$timestamp.timeago new Date()

      @$notification
      .css('height', 0)
      .prependTo($statusbar)
      .attr('class', state)
      .addClass("icon-#{icon} icon-large")
      .stop()
      .animate height: N_HEIGHT

      ++active_count
      @update()

    progress: (message, icon = 'clear') ->
      @show 'progress', message, icon

    success: (message, icon = 'check') ->
      @show 'success', message, icon
      setTimeout (=> @hide()), 3e3

    fail: (message, icon = 'ban') ->
      @show 'fail', message, icon
      setTimeout (=> @hide()), 6e3

  # Exports
  -> new Statusbar()


