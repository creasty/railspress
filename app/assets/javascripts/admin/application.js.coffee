
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
  $('a[href^=#]').click (e) ->
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

  #  Link Block
  #-----------------------------------------------
  $('.link-block').each ->
    $t = $ @
    link = $t.find('a').attr 'href'

    if link then $t.css('cursor', 'pointer'). on 'click tap', ->
      window.location.href = link

  #  Tooltip
  #-----------------------------------------------
  $('.tooltip, abbr[title]').powerTip
    placement: 'n'
    smartPlacement: true

  $('#menubar a').powerTip
    placement: 's'
    offset: 12
    smartPlacement: true

