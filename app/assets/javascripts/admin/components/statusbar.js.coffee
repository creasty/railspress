
define [
  'jquery'
  'flight/lib/component'
], ($, defineComponent) ->

  defineComponent ->

    #  Attrs
    #-----------------------------------------------
    @defaultAttrs
      threshold: 15
      height: 25
      duration: 300
      statusbarId: 'statusbar'
      showClass: 'show'

    #  Private
    #-----------------------------------------------
    hovering = false

    states =
      total: -> @inactive + @active
      active: 0
      inactive: 0
      none: 0

    #  Public
    #-----------------------------------------------
    @render = ->
      @$statusbar = $("<div id=\"#{@attr.statusbarId}\"/>").appendTo @$node

    @prepend = (e, $el) -> @$statusbar.prepend $el
    @append = (e, $el) -> @$statusbar.append $el

    @animate = (params, complete) ->
      @$statusbar
      .stop()
      .animate params,
        duration: @attr.duration
        complete: => complete?()

    @active = ->
      animate
        opacity: 1
        height: @attr.height

      @$statusbar.addClass @attr.showClass

    @inactive = ->
      animate
        opacity: 0
        height: @attr.threshold
      , =>
        @$statusbar.removeClass @attr.showClass

    @showAll = ->
      total = states.total()

      return @inactive() unless total > 0

      hovering = true

      animate
        opacity: 1
        height: total * @attr.height

      @$statusbar.addClass @attr.showClass

    @inactiveOrActive = ->
      hovering = false
      @update()

    @update = (e, state, former) ->
      --states[former] if former
      ++states[state]

      if hovering
        @showAll()
      else if states.active > 0
        @active()
      else
        @inactive()

      state

    #  Initializer
    #-----------------------------------------------
    @after 'initialize', ->
      @render()

      @attr.statusbarSelector = '#' + @attr.statusbarId

      @on 'mouseover', statusbarSelector: @showAll
      @on 'mouseout', statusbarSelector: @inactiveOrActive

      @on document, 'statusbarUpdate', @update
      @on document, 'statusbarPrependElement', @prepend
      @on document, 'statusbarAppendElement', @append

