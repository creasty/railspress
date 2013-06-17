
define [
  'jquery'
  'underscore'
  'backbone'
  'app/collections/posts'
  'app/views/posts/list_view'
  'common/notify'
  'common/alert'
  'components/viewstate'

  'backbone.syphon'
  'domReady!'
], (
  $
  _
  Backbone
  Posts
  ListView
  Notify
  Alert
  Viewstate
) ->

  #  Elements
  #-----------------------------------------------
  $main = $ '#main'

  #  Components
  #-----------------------------------------------
  UpdateNotify = Notify()

  #  Sidebar
  #-----------------------------------------------
  class SidebarView extends Backbone.View

    el: '#pocket_side'

    events:
      'click #page_first': 'pageFirst'
      'click #page_prev':  'pagePrev'
      'click #page_next':  'pageNext'
      'click #page_last':  'pageLast'

      'click #btn_update': 'update'
      'click #btn_delete_all': 'deleteAll'
      'click #btn_disselect': 'disselect'
      'keyup #page_num': 'pageGoto'
      'keyup #per_page': 'setPerPage'

    initialize: ->
      @listenTo Posts, 'change', @changeSidebar
      @listenTo Posts, 'destroy', @changeSidebar

      @$state = @$el.find '> div'
      @$counter = @$state.find 'span.counter'
      Viewstate.attachTo @$state

      @$pageNum = $ '#page_num'
      @$perPage = $ '#per_page'

      @changeSidebar()

    changeSidebar: ->
      selected = Posts.selected()
      count = selected.length

      if count > 1
        @$counter.html count
        @$state.trigger 'changeViewstate', 'selecting'
      else
        @$pageNum.val Posts.state.currentPage
        @$perPage.val Posts.state.pageSize
        @$state.trigger 'changeViewstate', 'normal'

    disselect: =>
      _.invoke Posts.selected(), 'toggle'

    deleteAll: (e) =>
      e.preventDefault()
      selected = Posts.selected()
      count = selected.length

      success = error = 0

      notify = ->
        return if count < success + error

        if error > 0
          UpdateNotify.fail "記事の削除に失敗しました (#{error}件)"
        else
          UpdateNotify.success "全 #{count} つの記事を削除しました"

      Alert
        title: "#{count} 件の記事を削除しますか？"
        message: '一度削除するともとに戻すことはできません。'
        type: 'danger'
        btns: [
          { text: '削除', action: 'destroy', type: 'danger' }
          { text: 'キャンセル', action: 'close', align: 'right' }
        ]
        callback: (action, al) =>
          if action == 'destroy'
            UpdateNotify.progress '記事を削除しています...'
            al.close()

            _.invoke selected, 'destroy',
              success: (model, res) ->
                ++success
                notify()
              error: ->
                ++error
                notify()

    update: ->
      selected = Posts.selected()

      if selected.length == 1
        data =
          title: $formTitle.val()
          description: $formDescription.val()

        post = selected[0]
        post.save data,
          success: (model, res) ->
            UpdateNotify.success res.message

    pageNext: (e) ->
      e.preventDefault()
      Posts.hasNext() && Posts.getNextPage()

    pagePrev: (e) ->
      e.preventDefault()
      Posts.hasPrevious() && Posts.getPreviousPage()

    pageFirst: (e) ->
      e.preventDefault()
      Posts.getFirstPage()

    pageLast: (e) ->
      e.preventDefault()
      Posts.getLastPage()

    pageGoto: (e) ->
      e.preventDefault()
      page = $(e.target).val() >>> 0
      Posts.getPage page

    setPerPage: (e) ->
      e.preventDefault()
      per = $(e.target).val() >>> 0
      Posts.setPageSize per


  #  App View
  #-----------------------------------------------
  class AppView extends Backbone.View

    el: '#posts_list'

    initialize: ->
      @listenTo Posts, 'add', @addOne
      @listenTo Posts, 'reset', @addAll
      @listenTo Posts, 'all', @render
      @listenTo Posts, 'destroy', @refresh
      @listenTo Posts, 'change', @bulk

      @refresh()

    refresh: ->
      $main.removeClass 'loaded'

      Posts.fetch
        success: (_, res) ->
          $main.addClass 'loaded'

    render: -> @

    bulk: ->
      count = Posts.selected().length

      if count > 1
        @$el.addClass 'bulk'
      else
        @$el.removeClass 'bulk'

    addOne: (post) ->
      view = new ListView model: post
      @$el.append view.render().$el

    addAll: ->
      @$el.html ''
      Posts.each @addOne, @

    updateSortBy: (e) ->
      e.preventDefault()
      currentSort = $('#sortByField').val()
      Posts.updateOrder currentSort


  #  Initialize Backbone App
  #-----------------------------------------------
  AppView = new AppView()
  SidebarView = new SidebarView()

