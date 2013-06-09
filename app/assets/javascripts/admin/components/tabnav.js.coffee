
define [
  'jquery'
  'flight/lib/component'
], ($, defineComponent) ->

  defineComponent ->
    @defaultAttrs
      show:            0

      currentClass:    'current'

      titleSelector:   '.tab-title'
      contentSelector: '.tab-content'
      navSelector:     '.tabnav > li'

    @init = ->
      @$contents = @select 'contentSelector'

      tabs = ''

      @select('titleSelector').each (i) ->
        title = $(@).html()
        tabs += "<li data-index=\"#{i}\">#{title}</li>"

      @$nav = $('<ul class="tabnav"></ul>').prependTo @$node
      @$tabs = $(tabs).appendTo @$nav

    @changeViewState = (e, index) ->
      @$tabs
      .removeClass(@attr.currentClass)
      .eq(index)
      .addClass @attr.currentClass

      @$contents
      .removeClass(@attr.currentClass)
      .eq(index)
      .addClass @attr.currentClass

    @onClick = (e) ->
      e.preventDefault()

      index = $(e.target).data('index') >>> 0
      @trigger 'changeViewState', index

    @after 'initialize', ->
      @init()

      @on 'changeViewState', @changeViewState
      @on 'click', navSelector: @onClick

      @trigger 'changeViewState', @attr.show if @attr.show?

