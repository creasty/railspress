
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

    render: ->
      @$el.html @template @model.toJSON()
      @$el.data 'model', @model
      @

    renderSelected: ->
      @$el.toggleClass 'selected'

