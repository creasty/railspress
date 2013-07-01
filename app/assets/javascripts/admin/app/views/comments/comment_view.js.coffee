
define [
  'jquery'
  'underscore'
  'backbone'
  'app/observers/comments'
  'text!app/templates/comments/comment.html'
  'common/alert'
  'common/notify'

  'powertip'
], (
  $
  _
  Backbone
  CommentsObserver
  CommentTemplate
  Alert
  Notify
) ->

  class CommentView extends Backbone.View

    tagName: 'div'
    className: 'comment'

    template: _.template CommentTemplate

    events:
      'click .btn.icon-reply': 'reply'
      'click .btn.icon-edit': 'edit'
      'click .btn.icon-delete': 'delete'

    initialize: ->
      @model.view = @

      @listenTo @model, 'change', @render
      @listenTo @model, 'destroy', @remove

    render: ->
      @$el.html @template @model.toJSON()
      @$el.data 'model', @model
      @

    reply: ->
      CommentsObserver.trigger 'reply', @model

    edit: ->
      CommentsObserver.trigger 'edit', @model

    delete: (e) ->
      e.preventDefault()

      notify = Notify()

      Alert
        title: 'このコメントを削除しますか？'
        message: '一度削除するともとに戻すことはできません。'
        type: 'danger'
        btns: [
          { text: '削除', action: 'destroy', type: 'danger' }
          { text: 'キャンセル', action: 'close', align: 'right' }
        ]
        callback: (action, al) =>
          if action == 'destroy'
            notify.progress 'コメントを削除しています...'
            al.close()

            @model.destroy
              wait: true
              success: (model, res) ->
                notify.success 'コメントを削除しました'

