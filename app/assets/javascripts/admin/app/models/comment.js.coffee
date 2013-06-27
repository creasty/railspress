
define [
  'underscore'
  'backbone'
], (_, Backbone) ->

  class Comment extends Backbone.Model

    urlRoot: '/admin/posts/comments'

    defualts:
      content:    ''
      user:       {}
      created_at: ''

    isSynced: -> @get('id')?
