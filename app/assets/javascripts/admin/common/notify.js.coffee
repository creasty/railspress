define ['jquery', 'common/timeago', 'domReady!'], ($) ->
  config =
    threshold: 15
    height: 25
    duration: 300
    parent: '#globalheader'
    statusbar: '<div id="statusbar"></div>'
    showClass: 'show'

  #  Statusbar UI
  #-----------------------------------------------
  Statusbar = new class
    states:
      active: 0
      inactive: 0
      none: 0

      total: -> @inactive + @active

    constructor: ->
      @hovering = false
      @$statusbar = $(config.statusbar).appendTo $ config.parent
      @events()

    events: ->
      @$statusbar.hover (=> @hover()), (=> @unhover())

    append: ($el) -> $el.appendTo @$statusbar
    prepend: ($el) -> $el.prependTo @$statusbar

    animate: (params, complete) ->
      @$statusbar
      .stop()
      .animate params,
        duration: config.duration
        complete: => complete?()

    active: ->
      @animate
        opacity: 1
        height: config.height

      @$statusbar.addClass config.showClass

    inactive: ->
      @animate
        opacity: 0
        height: config.threshold
      , =>
        @$statusbar.removeClass config.showClass

    hover: ->
      total = @states.total()

      return @inactive() unless total > 0

      @hovering = true
      @animate
        opacity: 1
        height: total * config.height

      @$statusbar.addClass config.showClass

    unhover: ->
      @hovering = false
      @update()

    update: (state, former) ->
      --@states[former] if former
      ++@states[state]

      if @hovering
        @hover()
      else if @states.active > 0
        @active()
      else
        @inactive()

      state


  #  Notify
  #-----------------------------------------------
  class Notify
    constructor: ->
      @create()

    create: ->
      @state = null
      @$notifi = $('<div></div>').height 0
      @$text = $('<span></span>').appendTo @$notifi
      @$close = $('<div class="close"></div>').appendTo @$notifi
      @$timestamp = $('<div class="timestamp"></div>').appendTo @$notifi

      @events()
      @

    events: ->
      @$notifi.on 'click', => @remove()
      @$close.on 'click', => @remove()

    animate: (params, complete) ->
      @$notifi
      .stop()
      .animate params,
        duration: config.duration
        complete: -> complete?()

    update: (state) -> @state = Statusbar.update state, @state

    active: (state, message, icon) ->
      @$text.text message

      @$timestamp
      .data('timestamp', +new Date())
      .timeago()

      Statusbar.prepend @$notifi
        .attr('class', state)
        .addClass("icon-#{icon} icon-large")

      @animate
        height: config.height
      , =>
        @update 'active'

    inactive: ->
      @update 'inactive'
      @animate
        height: 0
      , =>
        Statusbar.append @$notifi.height config.height

      clearTimeout @timer if @timer?
      @timer = setTimeout (=> @remove()), 12e4

    remove: ->
      clearTimeout @timer if @timer?
      @animate
        opacity: 0
        left: '-100%'
      , =>
        @$notifi.height 0
        @update 'none'

    progress: (message, icon = 'clear') ->
      @active 'progress', message, icon

    success: (message, icon = 'check') ->
      @active 'success', message, icon
      @timer = setTimeout (=> @inactive()), 3e3

    fail: (message, icon = 'ban') ->
      @active 'fail', message, icon
      @timer = setTimeout (=> @inactive()), 4e3


  -> new Notify()
