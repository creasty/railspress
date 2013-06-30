
define [
  'underscore'
  'backbone'
  'backbone.pageable'
  'app/models/comment_thread'
], (_, Backbone, PageableCollection, CommentThread) ->

  class CommentsThreadsCollection extends PageableCollection

    model: CommentThread

    url: '/admin/posts/comments.json'
    mode: 'infinite'

    state:
      currentPage: 1
      pageSize: 10

    queryParams:
      totalPages: null
      totalRecords: null

    selected: ->
      @filter (thread) -> thread.get 'selected'

  new CommentsThreadsCollection()
