
define [
  'jquery'
  'underscore'
  'backbone'
  'app/collections/posts'
  'app/views/posts/list_view'
  'common/notify'
  'common/alert'
  'components/viewstate'

  'powertip'
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

      'click #btn_search': 'search'

      'click #btn_refresh': 'refresh'

      'change #page_num': 'pageGoto'
      'change #per_page': 'setPerPage'

    initialize: ->
      @listenTo Posts, 'change', @changeSidebar
      @listenTo Posts, 'destroy', @changeSidebar
      @listenTo Posts, 'sync', @updateSidebar

      @$state = @$el.find '> div'
      @$counter = @$state.find 'span.counter'
      Viewstate.attachTo @$state

      @$page =
        num: $ '#page_num'
        size: $ '#page_size'
        display: $ '#page_display'

      @$post =
        status: $ '#post_status'
        user: $ '#post_user_id'

      @$search =
        title: $ '#search_title'
        status: $ '#search_status'
        userId: $ '#search_user_id'

    updateSidebar: ->
      q = Posts.queryParams
      s = Posts.state

      @$search.title.val q['search[title]']
      @$search.status.val q['search[status]']
      @$search.userId.val q['search[user_id]']

      @$page.num.val s.currentPage
      @$page.size.val s.pageSize
      @$page.display.html "全#{s.totalRecords}件"

      @$page.num.data 'powertip', "#{s.firstPage} - #{s.totalPages} の範囲を入力して下さい"

    changeSidebar: ->
      selected = Posts.selected()
      count = selected.length

      if count > 1
        @$counter.html count
        @$state.trigger 'changeViewstate', 'selecting'
      else
        @updatePager()
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
      count = selected.length

      success = error = 0

      notify = ->
        return if count < success + error

        if error > 0
          UpdateNotify.fail "記事の更新に失敗しました (#{error}件)"
        else
          UpdateNotify.success "全 #{count} つの記事を更新しました"

      data = {}

      if @$post.status.val()
        data.status = @$post.status.val()

      if @$post.user.val()
        data.user_id = @$post.user.val()

      Alert
        title: "#{count} 件の記事を更新しますか？"
        message: '選択ミスがないか十分に確認してください。'
        type: 'danger'
        btns: [
          { text: '更新', action: 'update', type: 'danger' }
          { text: 'キャンセル', action: 'close', align: 'right' }
        ]
        callback: (action, al) =>
          if action == 'update'
            UpdateNotify.progress '記事を更新しています...'
            al.close()

            _.each selected, (post) ->
              post.save data,
                success: (model, res) ->
                  ++success
                  notify()
                error: ->
                  ++error
                  notify()

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
      min = Posts.state.firstPage
      max = Posts.state.totalPages
      page = @$page.num.val() >>> 0
      page = Math.max min, Math.min(max, page)
      Posts.getPage page

    setPerPage: (e) ->
      e.preventDefault()
      Posts.setPageSize @$page.size.val() >>> 0

    search: ->
      q = Posts.queryParams
      q['search[title]'] = @$search.title.val()
      q['search[status]'] = @$search.status.val()
      q['search[user_id]'] = @$search.userId.val()

      Posts.fetch()

    refresh: ->
      q = Posts.queryParams
      q['search[title]'] = null
      q['search[status]'] = null
      q['search[user_id]'] = null

      Posts.fetch()


  #  Table Head View
  #-----------------------------------------------
  class TableView extends Backbone.View

    el: '#posts_list thead [data-sortby]'

    events:
      'click': 'sort'

    sort: (e) ->
      e.preventDefault()
      $t = $ e.currentTarget

      sort = (1 + ($t.data('sort') >>> 0)) % 3
      $t.data 'sort', sort

      @$el.removeClass 'desc asc'
      $t.addClass ['', 'desc', 'asc'][sort]

      if sort
        Posts.setSorting $t.data('sortby'), [1, -1][sort - 1]
        Posts.trigger 'sort'
      else
        Posts.setSorting null
        Posts.trigger 'sort'


  #  App View
  #-----------------------------------------------
  class AppView extends Backbone.View

    el: '#posts_list tbody'

    initialize: ->
      @listenTo Posts, 'add', @addOne
      @listenTo Posts, 'reset', @addAll
      @listenTo Posts, 'all', @render
      @listenTo Posts, 'destroy', @refresh
      @listenTo Posts, 'sort', @refresh
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


  #  Initialize Backbone App
  #-----------------------------------------------
  new AppView()
  new SidebarView()
  new TableView()

