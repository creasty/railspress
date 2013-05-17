
define [
  'jquery'
  'flight/component'
], ($, defineComponent) ->

  defineComponent ->

    #  Attrs
    #-----------------------------------------------
    @defaultAttrs
      threshold: 15
      height: 25
      duration: 300
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
    @prepend: (e, $el) -> @$node.prepend $el
    @append: (e, $el) -> @$node.append $el

    @animate = (params, complete) ->
      @$node
      .stop()
      .animate params,
        duration: @attr.duration
        complete: => complete?()

    @active: ->
      animate
        opacity: 1
        height: @attr.height

      @$node.addClass @attr.showClass

    @inactive: ->
      animate
        opacity: 0
        height: @attr.threshold
      , =>
        @$node.removeClass @attr.showClass

    @showAll: ->
      total = states.total()

      return @inactive() unless total > 0

      hovering = true

      animate
        opacity: 1
        height: total * @attr.height

      @$node.addClass @attr.showClass

    @inactiveOrActive: ->
      hovering = false
      @update()

    @update: (e, state, former) ->
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
      @on 'mouseover', @showAll
      @on 'mouseout', @inactiveOrActive

      @on document, 'statusbarUpdate', @update
      @on document, 'statusbarPrependElement', @prepend
      @on document, 'statusbarAppendElement', @append

