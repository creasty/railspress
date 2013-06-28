
define [
  'jquery'
  'underscore'
  'backbone'
  'text!app/templates/comments/comment.html'
], ($, _, Backbone, CommentTemplate) ->

  class CommentView extends Backbone.View

    tagName: 'div'
    className: 'comment'

    template: _.template CommentTemplate

    initialize: ->
      @model.view = @

      @listenTo @model, 'change', @render
      @listenTo @model, 'destroy', @remove

    render: ->
      @$el.html @template @model.toJSON()
      @$el.data 'model', @model
      @
