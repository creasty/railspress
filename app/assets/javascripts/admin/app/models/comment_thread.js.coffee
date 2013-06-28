
define [
  'underscore'
  'backbone'
], (_, Backbone) ->

  class CommentThread extends Backbone.Model

    urlRoot: '/admin/posts/comments'

    defualts:
      post_title: ''
      content:    ''
      user:       {}
      created_at: ''

    isSynced: -> @get('id')?
