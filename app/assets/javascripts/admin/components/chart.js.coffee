
define [
  'jquery'
  'flight/lib/component'

  'powertip'
  'common/smartresize'
], ($, defineComponent) ->

  defineComponent ->

    @defaultAttrs
      uiClassName: 'ui-chart'
      className: ''
      type: 'line'

      barMinHeight: 2

      padding: [0, 0, 0, 0]
      data: []
      labels: []
      tooltips: []
      unit: ''

      lineHtml: '<div class="line"></div>'
      dotHtml: '<div class="dot"></div>'

      barHtml: '<div class="bar"></div>'

      labelHtml: '<div class="label"></div>'

    @init = ->
      @$lines = []
      @$dots = []
      @$labels = []
      @$bars = []

      @len = @values.length
      @maximum = Math.max @values...
      @minimum = Math.min @values...

      @$container = $ '<div class="ui-chart-container"></div>'
      @$container.appendTo @$node
      @$container.addClass @attr.className

      @$node.addClass @attr.uiClassName

      if 'line' == @attr.type
        for i in [0...@len] by 1
          if i < @len - 1
            @$lines[i] =
              $(@attr.lineHtml)
              .css
                transformOrigin: '0 50%'
              .appendTo @$container

          @$dots[i] =
            $(@attr.dotHtml)
            .data('powertip', @tooltips[i] ? (@values[i] + @unit))
            .powerTip
              placement: 'n'
              smartPlacement: true
            .appendTo @$container
      else
        for i in [0...@len] by 1
          @$bars[i] =
            $(@attr.barHtml)
            .data('powertip', @tooltips[i] ? (@values[i] + @unit))
            .powerTip
              placement: 'n'
              smartPlacement: true
            .appendTo @$container

      for i in [0...@len] by 1
        @$labels[i] =
          $(@attr.labelHtml)
          .addClass(if i == 0 then 'first' else if i == @len - 1 then 'last' else null)
          .html(@labels[i])
          .appendTo @$container

    @render = ->
      @height = @$container.height()
      @width = @$container.width()

      @dx = @width / (@len - 1)

      @ratio =
        if @maximum == -@minimum
          1
        else
          @height / (@maximum - @minimum)

      if 'line' == @attr.type
        for i in [0...@len] by 1
          @drawLine i if i < @len - 1
          @drawDot i
          @renderLabelX i
      else
        for i in [0...@len] by 1
          @drawBar i
          @renderLabelX i

    @renderLabelX = (i) ->
      @$labels[i].css left: @getPosX i

    @drawLine = (i) ->
      rad = Math.atan (@getPosY(i + 1) - @getPosY(i)) / @dx

      len = @dx / Math.cos rad
      rot = -rad / Math.PI * 180

      @$lines[i].css
        transform: "rotate(#{rot}deg)"
        bottom: @getPosY i
        width: Math.ceil Math.abs len
        left: @getPosX i

    @drawDot = (i) ->
      @$dots[i].css
        bottom: @getPosY i
        left: @getPosX i

    @drawBar = (i) ->
      @$bars[i].css
        height: @attr.barMinHeight + @getPosY i
        left: @getPosX i

    @getPosX = (i) -> @dx * i | 0

    @getPosY = (i) -> @ratio * (@values[i] - @minimum) | 0

    @after 'initialize', ->
      @values = @$node.data('values') ? @attr.values
      @labels = @$node.data('labels') ? @attr.labels
      @tooltips = @$node.data('tooltips') ? @attr.tooltips
      @unit = @$node.data('unit') ? @attr.unit

      @init()
      @render()
      $(window).smartresize @render.bind @

