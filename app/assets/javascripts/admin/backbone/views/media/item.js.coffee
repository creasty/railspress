
define [
  'jquery'
  'underscore'
  'backbone'
  'model/medium'
  'text!views/media/_item.tpl'
], ($, _, Backbone, Medium, ItemHtml) ->

  medium = new Medium()

  class MediaView extends Backbone.View
    tagName: 'li'
    template: _.template ItemHtml

    events:
      'click': 'onClick'
      'click .delete': 'destory'

    initialize: ->
      @model.on 'destroy', @remove, @

    destory: ->
      @model.destory()

    remove: ->
      @$el.remove()

    onClick: ->


    render: ->
      tpl = @template @model.toJSON()
      @$el.html tpl
      @


  -> new MediaView model: medium

