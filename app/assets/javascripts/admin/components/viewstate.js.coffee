
define [
  'jquery'
  'flight/lib/component'
], ($, defineComponent) ->

  defineComponent ->
    $states = {}

    @defaultAttrs
      hideClass: 'hide'

    @cacheStates = ->
      @$node
      .each ->
        $t = $ @
        $states[$t.data 'state'] = $t

    @change = (e, state) ->
      return unless state

      @$node.addClass @attr.hideClass
      $states[state]?.removeClass @attr.hideClass

    @after 'initialize', ->
      @cacheStates()
      @on 'changeViewstate', @change

