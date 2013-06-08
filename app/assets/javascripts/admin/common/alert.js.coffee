
define ['jquery'], ($) ->

  class Alert
    constructor: (@config) ->
      @config = $.extend
        title: ''
        message: ''
        type: 'normal'
        btns: [text: 'OK', action: 'close']
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
      setTimeout @$popup.remove.bind(@), @config.duration

    open: ->
      @$title.text @config.title

      if $.isArray @config.message
        @config.message = "<ul><li>#{@config.message.join('</li><li>')}</li></ul>"

      @$message.html @config.message

      @$btns.append @config.btns.map (v) =>
        $btn = $ '<button class="btn"></button>'
        $btn.text v.text
        $btn.addClass "btn-#{v.type ? @config.type}"
        $btn.on 'click', => @config.callback v.action, @
        $btn.on 'click', @close.bind @ if v.action == 'close'

      @$alert.addClass @config.type

      @$popup.addClass 'show'

  (config) -> new Alert(config).open()
