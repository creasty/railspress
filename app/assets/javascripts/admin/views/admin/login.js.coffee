
require ['jquery'], ($) ->
  if navigator.userAgent.toLowerCase().indexOf('chrome') >= 0
    $ ->
      $('input:-webkit-autofill').each ->
        $t = $ @
        $clone = $t.clone true, true
        $t.after($clone).remove()
