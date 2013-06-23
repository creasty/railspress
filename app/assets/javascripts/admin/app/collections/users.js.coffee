
define [
  'underscore'
  'backbone'
  'backbone.pageable'
  'app/models/user'
], (_, Backbone, PageableCollection, User) ->

  class UsersCollection extends PageableCollection

    model: User

    url: '/admin/users.json'

    state:
      currentPage: 1
      pageSize: 10

    selected: ->
      @filter (post) -> post.get 'selected'

  new UsersCollection()
