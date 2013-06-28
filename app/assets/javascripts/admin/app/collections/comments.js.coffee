
define [
  'underscore'
  'backbone'
  'backbone.pageable'
  'app/models/comment'
], (_, Backbone, PageableCollection, Comment) ->

  class CommentsCollection extends PageableCollection

    model: Comment

    url: -> "/admin/posts/#{@post_id}/comments.json"
    mode: 'infinite'

    state:
      currentPage: 1
      pageSize: 20

    queryParams:
      totalPages: null
      totalRecords: null

  new CommentsCollection()
