
define [
  'underscore'
  'backbone'
  'backbone.pageable'
  'app/models/post'
], (_, Backbone, PageableCollection, Post) ->

  class PostsCollection extends PageableCollection

    url: '/admin/posts.json'

    model: Post

    state:
      currentPage: 1
      pageSize: 10

    filterByUser: (user_id) ->
      @filter (post) -> user_id == post.get 'user_id'

    selected: ->
      @filter (post) -> post.get 'selected'

  new PostsCollection()
