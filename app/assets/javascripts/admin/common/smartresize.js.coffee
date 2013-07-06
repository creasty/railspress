
define ['jquery'], ($) ->

  threshold = 100

  debounce = (func, threshold, execAsap) ->
    timeout = null

    debounced = ->
      obj = @
      args = arguments

      delayed = ->
        func.apply obj, args unless execAsap
        timeout = null

      if timeout
        clearTimeout timeout
      else if execAsap
        func.apply obj, args

      timeout = setTimeout delayed, threshold

  $.fn.smartresize = (fn) ->
    if fn
      @bind 'resize', debounce fn
    else
      @trigger sr
