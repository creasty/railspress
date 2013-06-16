
define [
  'jquery'
  'underscore'
  'backbone'
  'text!app/templates/posts/list_item.html'
], ($, _, Backbone, itemTemplate) ->

  class PostView extends Backbone.View

    tagName: 'tr'

    template: _.template itemTemplate

    events:
      'click':  'toggle'

    initialize: ->
      @model.view = @

      @listenTo @model, 'change:thumbnail', @render
      @listenTo @model, 'change:title', @render
      @listenTo @model, 'change:selected', @renderSelected

      @listenTo @model, 'destroy', @remove

    render: ->
      @$el.html @template @model.toJSON()
      @

    renderSelected: ->
      @$el.toggleClass 'selected'

    toggle: -> @model.toggle()
