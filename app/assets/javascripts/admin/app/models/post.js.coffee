
define [
  'underscore'
  'backbone'
], (_, Backbone) ->

  class Post extends Backbone.Model

    urlRoot: '/admin/posts'

    defualts:
      content:   ''
      status:    0
      title:     ''
      thumbnail: ''
      user_id:   0
      date_str:  ''
      time_str:  ''
      tags:      ''
      link:      ''

      selected: false

    toggle: -> @set 'selected', !@get 'selected'

    isSynced: -> @get('id')?
