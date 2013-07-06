
define [
  'jquery'
  'underscore'
  'backbone'
  'text!app/templates/notifications/topic.html'

  'common/timeago'
], ($, _, Backbone, TopicTemplate) ->

  class TopicView extends Backbone.View

    tagName: 'li'

    template: _.template TopicTemplate

    events:
      'mouseenter': 'makeRead'

    initialize: ->
      @model.view = @

      @listenTo @model, 'destroy', @remove
      @listenTo @model, 'change:read', @renderRead

      @renderRead()

    render: ->
      @$el.html @template @model.toJSON()
      @$el.data 'model', @model
      @$time = @$ 'time'
      @$time.timeago()
      @

    renderRead: ->
      if @model.get 'read'
        @$el.addClass 'read'
      else
        @$el.removeClass 'read'

    makeRead: ->
      return if @model.get 'read'
      @model.save 'read', true
