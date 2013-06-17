
define [
  'jquery'
  'underscore'
  'backbone'
  'text!app/templates/posts/list_item.html'
  'common/alert'
  'common/notify'
], ($, _, Backbone, itemTemplate, Alert, Notify) ->

  class PostView extends Backbone.View

    tagName: 'tr'

    template: _.template itemTemplate

    events:
      'click .checkbox':  'toggle'
      'click .icon-delete': 'delete'

    initialize: ->
      @model.view = @

      @listenTo @model, 'change:thumbnail', @render
      @listenTo @model, 'change:title', @render
      @listenTo @model, 'change:selected', @renderSelected

      @listenTo @model, 'destroy', @remove

    render: ->
      @$el.html @template @model.toJSON()
      @$checkbox = @$el.find '.checkbox'
      @

    renderSelected: ->
      @$checkbox.attr 'checked', @model.get 'selected'
      @$el.toggleClass 'selected'

    toggle: -> @model.toggle()

    delete: (e) ->
      e.preventDefault()

      notify = Notify()

      Alert
        title: 'この記事を削除しますか？'
        message: '一度削除するともとに戻すことはできません。'
        type: 'danger'
        btns: [
          { text: '削除', action: 'destroy', type: 'danger' }
          { text: 'キャンセル', action: 'close', align: 'right' }
        ]
        callback: (action, al) =>
          if action == 'destroy'
            notify.progress '記事を削除しています...'
            al.close()

            @model.destroy
              success: (model, res) ->
                notify.success '記事を削除しました'

