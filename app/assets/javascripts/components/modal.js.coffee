
define [
  'flight/lib/component'
#  'mixin/popup'
], (defineComponent, Popup) ->

  modal = ->
    @defaultAttrs
      duration: 300


  defineComponent modal
