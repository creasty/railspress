
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
      @filter (medium) -> medium.selected

    nextOrder: ->
      return 1 unless @length

      @last().get('order') + 1

    comparator: (medium) -> medium.get 'order'


  new MediaCollection()
