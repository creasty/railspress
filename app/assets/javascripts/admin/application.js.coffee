
#=== Rails UJS
#==============================================================================================
require ['jquery_ujs']


#=== General
#==============================================================================================
#  Remove Chrome's ugly autofill highlights
#-----------------------------------------------
if ~navigator.userAgent.toLowerCase().indexOf 'chrome'
  require ['jquery'], ($) -> $ ->
    $('input:-webkit-autofill').each ->
      $t = $ @
      $clone = $t.clone true, true
      $t.after($clone).remove()

#  Smooth Scrolling
#-----------------------------------------------
require ['jquery', 'easing'], ($) ->
  $(document).on 'click', 'a[href^=#]', (e) ->
    $t = $ @
    id = $t.attr 'href'

    return unless id[1..].length > 1

    $target = $ id

    return if $target.length == 0

    e.preventDefault()

    $('html, body').animate
      scrollTop: $target.offset().top
    ,
      duration: 600
      easing: 'easeInCubic'
      complete: -> window.location.hash = id

#  Tooltip
#-----------------------------------------------
require [
  'jquery'
  'powertip'
  'domReady!'
], ($) ->
  $('.tooltip, abbr[title], a[title]').powerTip
    placement: 'n'
    smartPlacement: true

  $('#menubar a').powerTip
    placement: 's'
    offset: 12
    smartPlacement: true


#=== Notification
#==============================================================================================
require ['common/notifications']

require ['jquery'], ($) ->

  opened = false
  $container = $ '#container'

  $(window).on 'mousemove', (e) ->
    if opened
      open = e.pageX <= 190
    else
      open = e.pageX <= 60

    return if open == opened
    opened = open

    if open
      $container.addClass 'open-menu'
    else
      $container.removeClass 'open-menu'


