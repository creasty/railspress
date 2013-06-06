define [
  'jquery'
  'underscore'
  'backbone'
  'model/medium'
], ($, _, Backbone, Medium) ->

  class Media extends Backbone.Collection
    model: Medium
