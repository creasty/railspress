
define [
  'underscore'
  'backbone'
  'backbone.pageable'
  'app/models/medium'
], (_, Backbone, PageableCollection, Medium) ->

  class MediaCollection extends PageableCollection

    model: Medium

    url: '/admin/media.json'
    mode: 'infinite'

    state:
      currentPage: 1
      pageSize: 20

    queryParams:
      modal: window.MODAL_NAME
      totalPages: null
      totalRecords: null

    selected: ->
      @filter (medium) -> medium.get 'selected'

  new MediaCollection()
