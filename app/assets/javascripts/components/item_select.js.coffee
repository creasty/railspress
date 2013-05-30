
define [
  'jquery'
  'flight/lib/component'
], ($, defineComponent) ->

  defineComponent ->
    @defaultAttrs
      eventType: 'click'

    @onAction = ->

    @after 'initialize', ->
      @on @attr.eventType, @onAction
