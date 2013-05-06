define ['jquery', 'common/timeago', 'domReady!'], ($) ->
  $statusbar = $('<div id="statusbar"></div>').appendTo $ '#globalheader'

  class NotificationCenter

    tableName: 'notifications'

    constructor: -> @refreash()

    refreash: ->
      data = localStorage.getItem @tableName
      data = $.parseJSON data if data
      @table = data ? {}
      @count = Object.keys(@table).length
      @table.alloc ?= 1000

    uid: -> ++@table.alloc

    update: -> localStorage.setItem @tableName, JSON.stringify @table

    get: (id) -> if id? then @table[id] ? {} else @table

    set: (obj, id) ->
      id ?= @uid()
      @table[id] = obj
      @update()
      id

    remove: (id) -> @set undefined, id


  class Statusbar

    constructor: (@nc) ->

    remove: ->
      return unless @$notification

      $n = @$notification
      count = @nc.count--
      @$notification = null

      $n.animate
        opacity: 0
        left: '-100%'
      ,
        duration: 300
        complete: =>
          $n.remove()
          $statusbar.removeClass 'has-notifications' if count == 1

    hide: ->
      return unless @$notification

      @$notification
      .animate
        height: 0
      ,
        duration: 300
        complete: =>
          @$notification.height(25).appendTo $statusbar

      setTimeout (=> @remove()), 12e4

    create: ->
      return if @$notification
      ++@nc.count

      @$notification = $ '<div></div>'
      @$text = $('<span></span>').appendTo @$notification
      @$close = $('<div class="close"></div>').appendTo @$notification
      @$timestamp = $('<div class="timestamp"></div>').appendTo @$notification

      @events()

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
      .animate height: 25

    progress: (message, icon = 'clear') ->
      @show 'progress', message, icon

    success: (message, icon = 'check') ->
      @show 'success', message, icon
      setTimeout (=> @hide()), 3e3

    fail: (message, icon = 'ban') ->
      @show 'fail', message, icon
      setTimeout (=> @hide()), 6e3


  class Notify

    constructor: ->
      @nc = new NotificationCenter()
      @init()
      @events()

    init: ->
      @refreash()

    events: ->
      $(window).on 'storage', =>
        @nc.refreash()
        @refreash()

      $statusbar.hover =>
        return if @nc.count < 1

        $statusbar.addClass 'has-notifications'

        $statusbar
        .stop()
        .animate
          height: 25 * @nc.count
        ,
          duration: 300
      , =>
        $statusbar
        .stop()
        .animate
          height: 5
        ,
          duration: 300
          complete: =>
            $statusbar.removeClass 'has-notifications'

    refreash: ->
      @clear()
      queues = @nc.get()
      for id, q of queues
        @set id, q

    clear: ->

    set: ->

    create: -> new Statusbar @nc

  # Exports
  -> new Notify()


