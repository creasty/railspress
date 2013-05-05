
require ['ujs', 'jquery.remotipart']

#  Remove Chrome's ugly autofill highlights
#-----------------------------------------------
if navigator.userAgent.toLowerCase().indexOf('chrome') >= 0
  require ['jquery'], ($) -> $ ->
    $('input:-webkit-autofill').each ->
      $t = $ @
      $clone = $t.clone true, true
      $t.after($clone).remove()

#  Highlight a current link in gnav
#-----------------------------------------------
###
require ['jquery'], ($) -> $ ->
  controller = $('body').attr 'id'

  $('#globalnav > li > a').each ->
    $t = $ @
    $t.parent().addClass 'current' if controller == $t.attr 'data-controller'

###