
define [
  'underscore'
  'backbone'
  'backbone.pageable'
  'app/models/post'
], (_, Backbone, PageableCollection, Post) ->

  class PostsCollection extends PageableCollection

    model: Post

    url: '/admin/posts.json'

    state:
      currentPage: 1
      pageSize: 10

    selected: ->
      @filter (post) -> post.get 'selected'

  new PostsCollection()
