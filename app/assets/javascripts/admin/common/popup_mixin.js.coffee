
define ['jquery'], ($) ->

  class Popup
    evnets: ->
      @$popup.on 'click', => @close()

    close = ->
      @$popup.removeClass 'show'

    open = ->
      @$popup.addClass 'show'

    toggle = ->
      @$popup.toggleClass 'show'

