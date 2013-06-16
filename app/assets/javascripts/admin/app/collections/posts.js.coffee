
define [
  'underscore'
  'backbone'
  'app/models/post'
], (_, Backbone, Post) ->

  class PostsCollection extends Backbone.Collection

    url: '/admin/posts'

    model: Post

    filterByUser: (user_id) ->
      @filter (post) -> user_id == post.get 'user_id'

    selected: ->
      @filter (post) -> post.get 'selected'

  new PostsCollection()
