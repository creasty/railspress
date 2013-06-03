define [
  'jquery'
  'underscore'
  'backbone'
  'collection/media'
], ($, _, Backbone, Media) ->

  class MediaView extends Backbone.View
    tagName: 'ul'

    render: ->
      @collection.each (medium) =>
        mediumView = new MediumView model: medium
        @$el.append mediumView.render().el

      @

  # mediaView = new MediaView collection: Media
