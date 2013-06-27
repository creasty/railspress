
define [
  'underscore'
  'backbone'
], (_, Backbone) ->

  class CommentThread extends Backbone.Model

    urlRoot: '/admin/posts/comments/threads'

    defualts:
      content:    ''
      user:       {}
      created_at: ''

    isSynced: -> @get('id')?
