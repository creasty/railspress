
define [
  'underscore'
  'backbone'
  'app/models/medium'
], (_, Backbone, Medium) ->

  class MediaCollection extends Backbone.Collection

    url: '/admin/media'

    model: Medium

    filterByType: (type) ->
      @filter (medium) -> type == medium.get 'type'

    selected: ->
      @filter (medium) -> medium.get 'selected'

  new MediaCollection()
