
define [
  'jquery'
  'underscore'
  'backbone'
  'text!app/templates/media/thumb_item.html'
], ($, _, Backbone, itemTemplate) ->

  class MediumView extends Backbone.View

    tagName: 'li'

    template: _.template itemTemplate

    events:
      'click':  'toggle'
      'mousemove': 'mouseMove'
      'mouseleave': 'mouseLeave'

    initialize: ->
      @model.view = @

      @listenTo @model, 'change:is_image', @render
      @listenTo @model, 'change:thumbnail', @render
      @listenTo @model, 'change:title', @renderTitle
      @listenTo @model, 'change:selected', @renderSelected

      @listenTo @model, 'destroy', @remove

    render: ->
      @$el.html @template @model.toJSON()
      @$preview = @$el.find '.preview-image'
      @$title = @$el.find '.title > span'
      @

    renderSelected: ->
      @$el.toggleClass 'selected'

    renderTitle: ->
      @$title.text @model.get 'title'

    mouseMove: (e) ->
      offset = @$preview.offset()
      w = @$preview.width()
      h = @$preview.height()
      x = (e.pageX - offset.left) / w * 100
      y = (e.pageY - offset.top) / h * 100

      @$preview.css backgroundPosition: "#{x}% #{y}%"

    mouseLeave: ->
      @$preview.css backgroundPosition: '50% 50%'

    toggle: -> @model.toggle()
