
define [
  'underscore'
  'backbone'
], (_, Backbone) ->

  class CommentThread extends Backbone.Model

    urlRoot: '/admin/posts/comments'

    isSynced: -> @get('id')?
