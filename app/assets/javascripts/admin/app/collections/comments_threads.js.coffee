
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
      pageSize: 20

    queryParams:
      totalPages: null
      totalRecords: null

  new CommentsThreadsCollection()
