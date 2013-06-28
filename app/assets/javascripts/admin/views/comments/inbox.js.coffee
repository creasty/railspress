
define [
  'jquery'
  'underscore'
  'backbone'
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
      'click li': 'toggle'

    initialize: ->
      @listenTo CommentsThreads, 'add', @addOne
      @listenTo CommentsThreads, 'reset', @addAll
      @listenTo CommentsThreads, 'change', @bulk

      @listenTo CommentsThreads, 'addLoader', @addLoader

      @$main = $ '#main'
      @$bottomOfList = $ '#bottom_of_list'

      # @$pocketBody.on 'scroll', @loadMore.bind(@)

      CommentsThreads.fetch
        success: =>
          @$main.addClass 'loaded'
          # @loadMore()

    addOne: (thread) ->
      view = new CommentThreadView model: thread
      $el = view.render().$el

      if thread.get('id')?
        @$el.append $el
      else
        @$el.prepend $el

    addAll: (_, ob) ->
      CommentsThreads.each @addOne, @
      CommentsThreads.add ob.previousModels, silent: true

    addLoader: (op) ->
      thread = new CommentsThreads.model
      thread.set op
      CommentsThreads.add thread

    toggle: (e) ->
      $t = $ e.currentTarget
      model = $t.data 'model'
      post_id = model.id

      return if Comments.post_id == post_id

      CommentsThreads.selected().forEach (thread) ->
        thread.toggle() if thread.id != model.id

      model.toggle()

      Comments.post_id = post_id
      Comments.fetch { post_id }

    loadMore: (e) ->
      buffer = 200

      bottomOfViewport = @$pocketBody.scrollTop() + @$pocketBody.height()

      bottomOfCollectionView = @$el.offset().top + @$el.height() - buffer

      unless !CommentsThreads.hasNext() || @isLoading || bottomOfViewport <= bottomOfCollectionView

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

    initialize: ->
      @listenTo Comments, 'add', @addOne
      @listenTo Comments, 'reset', @addAll
      @listenTo Comments, 'change', @bulk

      @listenTo Comments, 'clear', @clear

    bulk: ->
      console.log 124

    addOne: (comment) ->
      view = new CommentView model: comment
      $el = view.render().$el

      if comment.get('id')?
        @$el.append $el
      else
        @$el.prepend $el

    addAll: (_, ob) ->
      unless @postId == Comments.post_id
        @postId = Comments.post_id
        @$el.empty()

      Comments.each @addOne, @
      Comments.add ob.previousModels, silent: true

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

    create: ->

    focus: ->
      @$content.focus()

    activate: ->
      @$el.addClass 'active'

    disactivate: (e) ->
      @$el.removeClass 'active'
      updateSize e.target

    expand: (e) ->
      updateSize e.target
      ++e.target.rows

    updateSize = (el) ->
      el.rows = 2
      ++el.rows while el.scrollHeight > el.clientHeight && el.rows < 10


  #  Initialize Backbone App
  #-----------------------------------------------
  new ThreadsView()
  new CommentsView()
  new NewCommentView()

