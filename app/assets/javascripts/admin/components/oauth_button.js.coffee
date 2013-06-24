
define ['jquery', 'flight/lib/component'], ($, defineComponent) ->

  defineComponent ->

    @toggle = (e) ->
      e.preventDefault()

      if @$node.hasClass 'linked'
        @$window.trigger 'oauth:unlink', @attr.provider
      else
        @$window.trigger 'oauth:link', @attr.provider

    @linked = (e, provider) ->
      return unless provider == @attr.provider
      @$node.addClass 'linked'

    @unlinked = (e, provider) ->
      return unless provider == @attr.provider
      @$node.removeClass 'linked'

    @after 'initialize', ->
      @attr.provider ?= @$node.data 'provider'

      @$window = $ window
      @$window.on 'oauth:linked', @linked.bind(@)
      @$window.on 'oauth:unlinked', @unlinked.bind(@)

      @on 'click', @toggle
