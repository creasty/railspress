
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
      'click':  'toggleSelected'

    initialize: ->
      @listenTo @model, 'change', @render
      @listenTo @model, 'destroy', @remove
      @listenTo @model, 'toggle', @toggleSelected

    render: ->
      @$el.html @template @model.toJSON()
      @

    toggleSelected: ->
      @$el.toggleClass 'selected'
      @model.toggle()
      true

    clear: -> @model.destroy()
