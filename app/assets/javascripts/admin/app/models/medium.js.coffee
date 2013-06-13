
define [
  'underscore'
  'backbone'
], (_, Backbone) ->

  class Medium extends Backbone.Model

    urlRoot: '/admin/media'

    defualts:
      id:          ''
      title:       ''
      description: ''

      type:        ''
      preview:     false

      selected:    false

    toggle: ->
      @set selected: !@get 'selected'
