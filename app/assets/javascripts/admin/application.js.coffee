
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


#=== Global Navigation
#==============================================================================================
require ['jquery', 'domReady!'], ($) ->
  opened = false

  $body = $ 'body'
  $container = $ '#container'
  $globalnav = $ '#globalnav'
  $nav = $globalnav.find '> nav'

  animate = (container) ->
    $container
    .stop()
    .animate container,
      duration: 300
      easing: 'easeInOutExpo'

    $nav
    .stop()
    .animate
      scrollTop: 0
    ,
      duration: 300
      easing: 'easeInOutExpo'

  open = ->
    $body.addClass 'globalnav-open'
    animate
      left: 250
      right: 70 - 250

  close = ->
    $body.removeClass 'globalnav-open'
    animate
      left: 70
      right: 0

  $globalnav
  .on('mouseleave', close)
  .on 'mouseenter', open


#=== Notification
#==============================================================================================
require ['common/notifications']
