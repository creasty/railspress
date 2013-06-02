
require ['jquery_ujs']

#  Remove Chrome's ugly autofill highlights
#-----------------------------------------------
if navigator.userAgent.toLowerCase().indexOf('chrome') >= 0
  require ['jquery'], ($) -> $ ->
    $('input:-webkit-autofill').each ->
      $t = $ @
      $clone = $t.clone true, true
      $t.after($clone).remove()

