
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

    initialize: ->
      @model.view = @

      @listenTo @model, 'change:title', @render
      @listenTo @model, 'change:thumbnail', @render
      @listenTo @model, 'change:is_image', @render
      @listenTo @model, 'change:selected', @renderSelected

      @listenTo @model, 'destroy', @remove

    render: ->
      @$el.html @template @model.toJSON()
      @

    renderSelected: ->
      @$el.toggleClass 'selected'

    toggle: ->
      @model.toggle()

    clear: -> @model.destroy()
