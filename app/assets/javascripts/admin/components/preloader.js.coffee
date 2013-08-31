define [
  'jquery'
  'flight/lib/component'
], ($, defineComponent) ->

  defineComponent ->

    @init = ->
      img = new Image()
      img.onload = => @replaceImage()
      img.src = @attr.src

    @replaceImage = ->
      @$node
      .attr('src', @attr.src)
      .removeAttr('data-src')
      .css(opacity: 0)
      .animate
        opacity: 1
      ,
        duration: 300

      @$node.trigger 'imageLoaded'

    @after 'initialize', ->
      @attr.src ?= @$node.data 'src'
      @init()
