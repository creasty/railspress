
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

    render: ->
      @$el.html @template @model.toJSON()
      @

    toggleSelected: -> @model.toggle()

    clear: -> @model.destroy()


