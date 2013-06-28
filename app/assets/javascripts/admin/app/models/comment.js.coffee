
define [
  'underscore'
  'backbone'
], (_, Backbone) ->

  class Comment extends Backbone.Model

    # urlRoot: '/admin/posts/:post_id/comments(/:id)'

    defualts:
      content:    ''
      user:       {}
      created_at: ''

    url: ->
      url = ['/admin/posts', @post_id, 'comments']
      url.push @id if @id?
      url.join '/'

    isSynced: -> @get('id')?
