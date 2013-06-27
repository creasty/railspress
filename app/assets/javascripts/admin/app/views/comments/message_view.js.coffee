
define [
  'jquery'
  'underscore'
  'backbone'
  'text!app/templates/comments/message.html'
], ($, _, Backbone, MessageTemplate) ->

  class MessageView extends Backbone.View

    tagName: 'div'
    className: 'converstaion'

    template: _.template MessageTemplate

    initialize: ->
      @model.view = @

      @listenTo @model, 'change', @render
      @listenTo @model, 'destroy', @remove

    render: ->
      @$el.html @template @model.toJSON()
      @$el.data 'model', @model
      @
