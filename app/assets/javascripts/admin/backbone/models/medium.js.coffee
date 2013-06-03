
define [
  'jquery'
  'underscore'
  'backbone'
], ($, _, Backbone) ->

  class Medium extends Backbone.Model
    defualts:
      title: ''
      description: ''
      id: ''
      type: ''
      selected: false

    toggle: ->
      @set 'selected', !@get 'selected'

