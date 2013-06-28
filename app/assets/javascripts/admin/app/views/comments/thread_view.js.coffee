
define [
  'jquery'
  'underscore'
  'backbone'
  'text!app/templates/comments/thread.html'
], ($, _, Backbone, ThreadTemplate) ->

  class TheadView extends Backbone.View

    tagName: 'li'

    template: _.template ThreadTemplate

    initialize: ->
      @model.view = @

      @listenTo @model, 'change', @render
      @listenTo @model, 'destroy', @remove
      @listenTo @model, 'change:selected', @renderSelected

    render: ->
      @$el.html @template @model.toJSON()
      @$el.data 'model', @model
      @

    renderSelected: ->
      if @model.get 'selected'
        @$el.addClass 'selected'
      else
        @$el.removeClass 'selected'
