
define [
  'underscore'
  'backbone'
], (_, Backbone) ->

  class Medium extends Backbone.Model

    urlRoot: '/admin/media'

    defualts:
      id:          null
      title:       ''
      description: ''
      file_name:   ''
      file_size:   0
      file_type:   ''

      selected: false

    toggle: -> @set 'selected', !@get 'selected'
