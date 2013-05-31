
define [
  'jquery'
  'flight/lib/component'
], ($, defineComponent) ->

  defineComponent ->
    counter = 0
    $selectedItems = {}

    @defaultAttrs
      eventType: 'click'
      selectedClass: 'selected'
      itemSelector: null

    @onAction = (e) ->
      $t = $ e.currentTarget
      flag = !$t.data 'selected'
      id = $t.data 'id'

      $t.data 'selected', flag

      if flag
        ++counter
        $selectedItems[id] = $t
        $t.addClass @attr.selectedClass
      else
        --counter
        $selectedItems[id] = undefined
        $t.removeClass @attr.selectedClass

      @trigger 'select', [counter, $t, $selectedItems]

      e.preventDefault()

    @after 'initialize', ->
      @$node.find(@attr.itemSelector).on @attr.eventType, @onAction.bind(@)

