define [
  'jquery'
  'underscore'
  'backbone'
  'model/medium'
], ($, _, Backbone, Medium) ->

  class Media extends Backbone.Collection
    model: Medium

  media = new Media(
    { title: 'title 1', selected: true }
    { title: 'title 2' }
    { title: 'title 3' }
  )

