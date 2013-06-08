
define ['jquery'], ($) ->

  class Alert
    constructor: (@config) ->
      @config = $.extend
        title: ''
        message: ''
        type: 'normal'
        btns: [text: 'OK', action: 'close', type: 'danger']
        callback: $.noop
        duration: 300
      , @config

      @init()
      @events()

    init: ->
      @$popup = $ '<div></div>'
      @$overlay = $ '<div class="overlay overlay-alert"></div>'
      @$alert = $ '<div class="alert"></div>'

      @$title = $ '<h2></h2>'
      @$message = $ '<div></div>'
      @$btns = $ '<footer></footer>'

      @$alert.append @$title, @$message, @$btns
      @$popup.append @$alert, @$overlay
      @$popup.appendTo $ 'body'

    events: ->
      @$overlay.on 'click', => @close()

    close: ->
      @$popup.removeClass 'show'
      setTimeout (=> @$popup.remove()), @config.duration

    open: ->
      @$title.text @config.title

      if $.isArray @config.message
        @config.message = "<ul><li>#{@config.message.join('</li><li>')}</li></ul>"

      @$message.html @config.message

      @config.btns.forEach (v) =>
        $btn = $ '<button class="btn"></button>'
        $btn.text v.text
        $btn.addClass "btn-#{v.type}"
        $btn.addClass "float-#{v.align ? 'none'}"
        $btn.on 'click', => @config.callback v.action, @
        $btn.on 'click', @close.bind @ if v.action == 'close'
        $btn.width v.width
        @$btns.append $btn

      @$alert.addClass @config.type

      setTimeout (=> @$popup.addClass 'show'), 1

  (config) -> new Alert(config).open()
