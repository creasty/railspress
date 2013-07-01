
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
      'click .icon-reply': 'reply'
      'click .icon-edit': 'edit'
      'click .icon-delete': 'delete'

      'click .icon-check': 'save'
      'click .icon-ban': 'discard'

    initialize: ->
      @model.view = @

      @listenTo @model, 'change', @render
      @listenTo @model, 'destroy', @remove

    render: ->
      @$el.html @template @model.toJSON()
      @$el.data 'model', @model

      @$message = @$ '.message'
      @$edit = @$ '.edit'
      @$textarea = @$ '.edit > textarea'

      @$('time').timeago()
      @$('.btn-link').powerTip
        placement: 's'
        smartPlacement: true

      @

    reply: ->
      CommentsObserver.trigger 'reply', @model

    edit: ->
      @$message.addClass 'hide'
      @$edit.removeClass 'hide'
      @$textarea.val @model.get 'content'

    save: ->
      notify = Notify()
      notify.progress '変更を保存しています...'

      @model.save { content: @$textarea.val() },
        success: =>
          notify.success '変更を保存しました...'
          @discard()
        error: ->
          notify.fail '保存に失敗しました...'

    discard: ->
      @$message.removeClass 'hide'
      @$edit.addClass 'hide'

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

