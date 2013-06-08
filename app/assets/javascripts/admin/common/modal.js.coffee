
define [
  'flight/lib/component'
  'mixin/popup'
], (defineComponent, Popup) ->

  defineComponent ->
    @defaultAttrs
      duration: 300
