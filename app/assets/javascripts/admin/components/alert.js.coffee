
define [
  'jquery'
  'flight/lib/component'
  # 'mixin/popup'
], ($, defineComponent, PopupMixin) ->

  Alert = ->

  #  Overlay
  #-----------------------------------------------
  $(document).on 'click', '.overlay', (e) ->
    $t = $(@).parent().removeClass 'show'

  #  Modal / Alert
  #-----------------------------------------------
  $(document).on 'click',
    '[data-toggle="modal"], [data-toggle="alert"]',
    (e) ->
      $t = $ @
      $($t.data('target')).toggleClass 'show'
      e.preventDefault()


  defineComponent Alert, PopupMixin
