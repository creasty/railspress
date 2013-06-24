
define ['jquery', 'flight/lib/component'], ($, defineComponent) ->

  defineComponent ->

    @defaultAttrs
      provider:    ''
      changeText:  true
      linkedText:  '接続しています'

    @toggle = (e) ->
      e.preventDefault()

      return if @isPending
      @isPending = true

      if @$node.hasClass 'linked'
        @$window.trigger 'oauth:unlink', @attr.provider
      else
        @$window.trigger 'oauth:link', @attr.provider

    @linked = (e, provider) ->
      return unless provider == @attr.provider
      @isPending = false
      @$node.addClass 'linked'
      @$node.text @attr.linkedText if @attr.changeText

    @unlinked = (e, provider) ->
      return unless provider == @attr.provider
      @isPending = false
      @$node.removeClass 'linked'
      @$node.text @attr.defaultText if @attr.changeText

    @after 'initialize', ->
      @attr.provider = @$node.data('provider') ? @attr.provider
      @attr.defaultText ?= @$node.text()
      @attr.linkedText = @$node.data('linked') ? @attr.linkedText

      @$window = $ window
      @$window.on 'oauth:linked', @linked.bind(@)
      @$window.on 'oauth:unlinked', @unlinked.bind(@)

      @on 'click', @toggle
