
define [
  'underscore'
  'backbone'
], (_, Backbone) ->

  class User extends Backbone.Model

    urlRoot: '/admin/users'

    defualts:
      name:  ''
      email: ''
      oauth: null
      admin: false

      selected: false

    toggle: -> @set 'selected', !@get 'selected'

    isSynced: -> @get('id')?
