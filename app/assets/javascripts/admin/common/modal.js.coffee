
define ['jquery'], ($) ->

  $modals = {}
  uuid = 0

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
      @uuid = "modal_iframe_#{uuid++}"

    events: ->
      @$overlay.on 'click', => @close()
      @$closebtn.on 'click', => @close()

    close: ->
      @$popup.removeClass 'show'

      if @config.destroy
        setTimeout (=> @$popup.remove()), @config.duration
        @isloaded = false
        @$node = null
      else
        setTimeout =>
          @trigger 'modalClose', [@$body, @$modal]
        , @config.duration

    trigger: (type, args) ->
      return unless @$node
      @$node.trigger type, args

    getContent: (onload) ->
      return onload() if @isloaded
      @isloaded = true

      @$modal.removeClass 'error'

      if @config.content instanceof $
        @$body.append @$node = @config.content
        onload()
      else if @config.content.match /^#[\w\-]+$/
        @$body.append @$node = $ @config.content
        onload()
      else if @config.iframe
        $iframe = $ "<iframe name=\"#{@uuid}\" frameborder=\"0\" allowtransparency=\"true\" width=\"100%\" height=\"100%\"></iframe>"
        $iframe.attr 'src', @config.content
        @$body.append @$node = $iframe
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
        @trigger 'modalOpen', [@$body, @$modal]
        setTimeout (=> @$popup.addClass 'show'), 1

  (config) -> new Modal config
