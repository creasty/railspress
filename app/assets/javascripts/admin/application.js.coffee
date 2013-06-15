
require ['jquery_ujs']


#  Remove Chrome's ugly autofill highlights
#-----------------------------------------------
if navigator.userAgent.toLowerCase().indexOf('chrome') >= 0
  require ['jquery'], ($) -> $ ->
    $('input:-webkit-autofill').each ->
      $t = $ @
      $clone = $t.clone true, true
      $t.after($clone).remove()


require [
  'jquery'
  'powertip'
  'domReady!'
], ($) ->

  #  Smooth Scrolling
  #-----------------------------------------------
  $(document).on 'click', 'a[href^=#]', (e) ->
    e.preventDefault()

    $t = $ @
    id = $t.attr 'href'
    $target = $ id

    return if $target.length == 0

    $('html, body').animate
      scrollTop: $target.offset().top
    ,
      duration: 600
      # easing: 'easeInCubic'
      complete: -> window.location.hash = id

  #  Tooltip
  #-----------------------------------------------
  $('.tooltip, abbr[title]').powerTip
    placement: 'n'
    smartPlacement: true

  $('#menubar a').powerTip
    placement: 's'
    offset: 12
    smartPlacement: true

