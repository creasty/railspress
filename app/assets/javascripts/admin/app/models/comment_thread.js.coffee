
define [
  'underscore'
  'backbone'
], (_, Backbone) ->

  class CommentThread extends Backbone.Model

    urlRoot: '/admin/posts/comments'

    defualts:
      selected: false

    toggle: -> @set 'selected', !@get 'selected'

    isSynced: -> @get('id')?
