
define ['jquery'], ($) ->

  class Modal
    constructor: (@config) ->
      @config = $.extend
        content: ''
        callback: $.noop
        type: ''
        iframe: false
        duration: 300
        destroy: false
      , @config

      @init()
      @events()

    init: ->
      @$popup = $ '<div></div>'
      @$overlay = $ '<div class="overlay"></div>'
      @$modal = $ '<div class="modal"></div>'
      @$closebtn = $ '<div class="close-btn"></div>'
      @$body = $ '<div></div>'

      @$modal.append @$closebtn, @$body
      @$popup.append @$modal, @$overlay
      @$popup.appendTo $ 'body'

    events: ->
      @$overlay.on 'click', => @close()
      @$closebtn.on 'click', => @close()

    close: ->
      @$popup.removeClass 'show'

      if @config.destroy
        setTimeout (=> @$popup.remove()), @config.duration
        @isloaded = false

    getContent: (onload) ->
      return onload() if @isloaded
      @isloaded = true

      @$modal.removeClass 'error'

      if @config.content.match /^#[\w\-]+$/
        @$body.append $ @config.content
        onload()
      else if @config.iframe
        $iframe = $ '<iframe frameborder="0"></iframe>'
        $iframe.attr 'src', @config.content
        @$body.append $iframe
        $iframe.on 'load', onload
      else
        $.ajax
          url: @config.content
        .done (content) =>
          @$body.html content
          onload()
        .fail =>
          @$modal.addClass 'error'
          @isloaded = false
          onload()

    open: ->
      if $.isArray @config.message
        @config.message = "<ul><li>#{@config.message.join('</li><li>')}</li></ul>"

      @$modal.addClass @config.type

      @getContent =>
        @config.callback @$body, @$modal
        setTimeout (=> @$popup.addClass 'show'), 1

  (config) -> new Modal config
