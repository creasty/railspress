
define [
  'jquery'
  'underscore'
  'backbone'
  'app/observers/comments'
  'app/collections/comments_threads'
  'app/collections/comments'
  'app/views/comments/thread_view'
  'app/views/comments/comment_view'
  'common/notify'
  'common/alert'

  'backbone.syphon'
  'domReady!'
], (
  $
  _
  Backbone
  CommentsObserver
  CommentsThreads
  Comments
  CommentThreadView
  CommentView
  Notify
  Alert
  Modal
) ->

  #  Components
  #-----------------------------------------------
  UpdateNotify = Notify()
  UploaderNotify = Notify()

  #  App View
  #-----------------------------------------------
  class ThreadsView extends Backbone.View

    el: '#threads_list'

    events:
      'click li': 'loadComments'
      'scroll':   'loadMore'

    initialize: ->
      @listenTo CommentsThreads, 'add', @addOne
      @listenTo CommentsThreads, 'reset', @addAll
      @listenTo CommentsThreads, 'change', @bulk

      @$main = $ '#main'

      CommentsThreads.fetch
        success: =>
          @$main.addClass 'loaded'
          @loadComments null, CommentsThreads.at(0).id
          @loadMore()

    addOne: (thread) ->
      view = new CommentThreadView model: thread
      $el = view.render().$el

      if thread.isSynced()?
        @$el.append $el
      else
        @$el.prepend $el

    addAll: (_, ob) ->
      CommentsThreads.each @addOne, @
      CommentsThreads.add ob.previousModels, at: 0, silent: true

    loadComments: (e, post_id) ->
      unless post_id
        $t = $ e.currentTarget
        model = $t.data 'model'
        post_id = model.id

      return if Comments.post_id == post_id

      CommentsThreads.selected().forEach (thread) ->
        thread.toggle() if thread.id != model.id

      CommentsThreads.where(id: post_id)[0].toggle()

      Comments.trigger 'loadComments', post_id

    loadMore: (e) ->
      buffer = 100

      bottomOfViewport = @$el.scrollTop() + @$el.height()

      last = CommentsThreads.at CommentsThreads.models.length - 1
      $last = last.view.$el

      bottomOfCollectionView = @$el.scrollTop() + $last.offset().top + $last.height() - buffer

      if CommentsThreads.hasNext() && !@isLoading && bottomOfViewport > bottomOfCollectionView

        @isLoading = true

        CommentsThreads.getNextPage
          remove: false
          update: true
          success: =>
            @isLoading = false


  #  Comments View
  #-----------------------------------------------
  class CommentsView extends Backbone.View

    el: '#comments_list'

    events:
      'scroll': 'loadMore'

    initialize: ->
      @listenTo Comments, 'add', @addOne
      @listenTo Comments, 'reset', @addAll
      @listenTo Comments, 'clear', @clear
      @listenTo Comments, 'loadComments', @loadComments
      @listenTo Comments, 'addNew', @addNew

      @$thread = $ '#thread'
      @$thread.on 'scroll', @loadMore.bind(@)

    loadComments: (post_id) ->
      @$thread.removeClass 'loaded'

      Comments.post_id = post_id
      Comments.fetch
        post_id: post_id,
        success: =>
          @$thread.addClass 'loaded'

    addNew: (op) ->
      comment = new Comments.model
      comment.set 'post_id', Comments.post_id

      comment.save op,
        success: ->
          Comments.add comment
          CommentsObserver.trigger 'addedNew'

    addOne: (comment) ->
      view = new CommentView model: comment
      $el = view.render().$el

      if comment.get 'was_created'
        @$el.prepend $el
      else
        @$el.append $el

    addAll: (_, ob) ->
      unless @postId == Comments.post_id
        @postId = Comments.post_id
        @$el.empty()

      Comments.each @addOne, @
      Comments.add ob.previousModels, at: 0, silent: true

    loadMore: ->
      buffer = 345

      bottomOfViewport = @$el.scrollTop() + @$el.height()

      last = Comments.at Comments.models.length - 1
      $last = last.view.$el

      bottomOfCollectionView = @$el.scrollTop() + $last.offset().top + $last.height() - buffer

      if Comments.hasNext() && !@isLoading && bottomOfViewport > bottomOfCollectionView

        @isLoading = true

        Comments.getNextPage
          remove: false
          update: true
          success: =>
            @isLoading = false


  #  New Comment View
  #-----------------------------------------------
  class NewCommentView extends Backbone.View

    el: '#new_comment'

    events:
      'click': 'focus'
      'click button': 'create'
      'focus #comment_content': 'activate'
      'blur #comment_content': 'disactivate'
      'keyup #comment_content': 'expand'

    initialize: ->
      @$content = $ '#comment_content'

      @listenTo CommentsObserver, 'reply', @reply
      @listenTo CommentsObserver, 'addedNew', @resetContent

    create: ->
      Comments.trigger 'addNew', content: @$content.val()

    resetContent: ->
      @$content.val ''
      @updateSize()

    reply: (model) ->
      @focus()
      @$content.val "@#{model.get 'user_username'} "

      el = @$content.get 0

      if el.createTextRange
        range = el.createTextRange()
        range.move 'character', el.value.length
        range.select()
      else if el.setSelectionRange
        el.setSelectionRange el.value.length, el.value.length

    focus: ->
      @$content.focus()

    activate: ->
      @$el.addClass 'active'

    disactivate: (e) ->
      @$el.removeClass 'active'
      @updateSize()

    expand: (e) ->
      @updateSize()
      ++e.target.rows

    updateSize: ->
      el = @$content.get 0
      el.rows = 2
      ++el.rows while el.scrollHeight > el.clientHeight && el.rows < 10


  #  Initialize Backbone App
  #-----------------------------------------------
  new ThreadsView()
  new CommentsView()
  new NewCommentView()

