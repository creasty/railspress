
define [
  'jquery'
  'flight/lib/component'
], ($, defineComponent) ->

  defineComponent ->
    @change = (e, groupName, stateName) ->
      $("[data-group]")
      .filter ->
        groupName == $(@).data 'group'
      .removeClass 'show'
      .filter ->
        stateName == $(@).data 'state'
      .addClass 'show'

    @after 'initialize', ->
      $(document).on 'changeViewState', @change

