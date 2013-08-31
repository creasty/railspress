
define [
  'jquery'
  'underscore'
  'backbone'
  'app/observers/comments'
  'text!app/templates/comments/comment.html'
  'common/alert'
  'common/notify'
  'components/preloader'

  'powertip'
], (
  $
  _
  Backbone
  CommentsObserver
  CommentTemplate
  Alert
  Notify
  Preloader
) ->

  class CommentView extends Backbone.View

    tagName: 'div'
    className: 'comment'

    template: _.template CommentTemplate

    events:
      'click .icon-reply': 'reply'
      'click .icon-edit': 'edit'
      'click .icon-delete': 'delete'

      'click .btn-success': 'save'
      'click .btn-danger': 'discard'

      'click .icon-good': 'like'
      'click .icon-bad': 'dislike'

    initialize: ->
      @model.view = @

      @listenTo @model, 'change', @render
      @listenTo @model, 'destroy', @remove

    render: ->
      @$el.html @template @model.toJSON()
      @$el.data 'model', @model

      @$message = @$ '.message'
      @$edit = @$ '.edit'
      @$controller = @$ '.controller'
      @$textarea = @$ '.edit > textarea'

      @$like = @$ '.icon-good'
      @$dislike = @$ '.icon-bad'

      Preloader.attachTo @$el.find 'img'

      @$('time').timeago()
      @$('.tooltip').powerTip
        placement: 's'
        smartPlacement: true

      @

    reply: ->
      CommentsObserver.trigger 'reply', @model

    edit: ->
      @$message.addClass 'hide'
      @$edit.removeClass 'hide'
      @$controller.addClass 'hide'
      @$textarea.val @model.get 'content'

    save: ->
      notify = Notify()
      notify.progress '変更を保存しています...'

      @model.save { content: @$textarea.val() },
        success: =>
          notify.success '変更を保存しました'
          @discard()
        error: ->
          notify.fail '保存に失敗しました'

    discard: ->
      @$message.removeClass 'hide'
      @$edit.addClass 'hide'
      @$controller.removeClass 'hide'

    remove: ->
      @$el.animate
        left: '-100%'
        height: 0
        opacity: 0
      ,
        duration: 300
        easing: 'easeInCubic'
        complete: =>
          @$el.remove()

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

    rating: (url) ->
      @rating_pending = true

      $.ajax
        url: url
        type: 'post'

        complete: =>
          @rating_pending = false

        success: (data) =>
          @model.set 'my_rating', data.state

          switch data.state
            when 'like'
              @$like.addClass 'active'
              @$dislike.removeClass 'active'
            when 'dislike'
              @$like.removeClass 'active'
              @$dislike.addClass 'active'
            when 'unlike'
              @$like.removeClass 'active'
              @$dislike.removeClass 'active'

          @$like.html data.like_counts
          @$dislike.html data.dislike_counts

    unlike: -> @rating "#{@model.url()}/unlike"

    like: ->
      return if @rating_pending

      if 'like' == @model.get 'my_rating'
        @unlike()
      else
        @rating "#{@model.url()}/like"

    dislike: ->
      return if @rating_pending

      if 'dislike' == @model.get 'my_rating'
        @unlike()
      else
        @rating "#{@model.url()}/dislike"


