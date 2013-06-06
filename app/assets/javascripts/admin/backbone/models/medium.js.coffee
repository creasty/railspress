
define [
  'jquery'
  'underscore'
  'backbone'
], ($, _, Backbone) ->

  class Medium extends Backbone.Model
    defualts:
      id:          ''
      title:       ''
      description: ''

      type:        ''
      preview:     false

      selected:    false

    toggle: ->
      @set 'selected', !@get 'selected'

