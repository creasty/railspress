
define [
  'jquery'
  'underscore'
  'backbone'
  'app/collections/users'
  'app/views/users/list_view'
  'common/notify'
  'common/alert'
  'components/viewstate'

  'powertip'
  'domReady!'
], (
  $
  _
  Backbone
  Users
  ListView
  Notify
  Alert
  Viewstate
) ->

  #  Components
  #-----------------------------------------------
  UpdateNotify = Notify()


  #  App View
  #-----------------------------------------------
  class AppView extends Backbone.View

    el: '#users_list tbody'

    initialize: ->
      @listenTo Users, 'add', @addOne
      @listenTo Users, 'reset', @addAll
      @listenTo Users, 'all', @render
      @listenTo Users, 'destroy', @refresh
      @listenTo Users, 'sort', @refresh
      @listenTo Users, 'change', @bulk

      @$main = $ '#main'

      @refresh()

    refresh: ->
      return if Users.isProcessing

      @$main.removeClass 'loaded'

      Users.fetch
        success: (_, res) =>
          @$main.addClass 'loaded'

    render: -> @

    bulk: ->
      count = Users.selected().length

      if count > 1
        @$el.addClass 'bulk'
      else
        @$el.removeClass 'bulk'

    addOne: (user) ->
      view = new ListView model: user
      @$el.append view.render().$el

    addAll: ->
      @$el.html ''
      Users.each @addOne, @


  #  Table Head View
  #-----------------------------------------------
  class TableView extends Backbone.View

    el: '#users_list thead [data-sortby]'

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
        Users.setSorting $t.data('sortby'), [1, -1][sort - 1]
        Users.trigger 'sort'
      else
        Users.setSorting null
        Users.trigger 'sort'


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
      'change #page_size': 'setPerPage'

    initialize: ->
      @$state = @$el.find '> div'
      @$counter = @$state.find 'span.counter'
      Viewstate.attachTo @$state

      @$page =
        num: $ '#page_num'
        size: $ '#page_size'
        display: $ '#page_display'

      @$user =
        admin: $ '#user_admin'

      @$search =
        name: $ '#search_name'
        admin: $ '#search_admin'

      @listenTo Users, 'change', @changeSidebar
      @listenTo Users, 'destroy', @changeSidebar
      @listenTo Users, 'sync', @updateSidebar

    updateSidebar: ->
      q = Users.queryParams
      s = Users.state

      @$search.name.val q['search[name]']
      @$search.admin.val q['search[admin]']

      @$page.num.val s.currentPage
      @$page.size.val s.pageSize
      @$page.display.html "全#{s.totalRecords}件"

      @$page.num.data 'powertip', "#{s.firstPage} - #{s.totalPages} の範囲を入力して下さい"

    changeSidebar: ->
      selected = Users.selected()
      count = selected.length

      if count > 1
        @$counter.html count
        @$state.trigger 'changeViewstate', 'selecting'
      else
        @updateSidebar()
        @$state.trigger 'changeViewstate', 'normal'

    disselect: =>
      _.invoke Users.selected(), 'toggle'

    deleteAll: (e) =>
      e.preventDefault()
      selected = Users.selected()
      count = selected.length

      success = error = 0

      notify = ->
        return if count > success + error

        if error > 0
          UpdateNotify.fail "ユーザの削除に失敗しました (#{error}件)"
        else
          UpdateNotify.success "全 #{count} ユーザを削除しました"

        Users.isProcessing = false
        Users.trigger 'destroy'

      Alert
        title: "#{count} 件のユーザを削除しますか？"
        message: '関連するデータも全て削除します。<br />一度削除したユーザは復元することができません。'
        type: 'danger'
        btns: [
          { text: '削除', action: 'destroy', type: 'danger' }
          { text: 'キャンセル', action: 'close', align: 'right' }
        ]
        callback: (action, al) =>
          if action == 'destroy'
            UpdateNotify.progress 'ユーザを削除しています...'
            al.close()

            Users.isProcessing = true

            _.invoke selected, 'destroy',
              wait: true
              success: (model, res) ->
                ++success
                notify()
              error: ->
                ++error
                notify()

    update: ->
      selected = Users.selected()
      count = selected.length

      success = error = 0

      notify = ->
        return if count > success + error

        if error > 0
          UpdateNotify.fail "ユーザの更新に失敗しました (#{error}件)"
        else
          UpdateNotify.success "全 #{count} ユーザを更新しました"

      data = {}

      if @$user.admin.val()
        data.admin = @$user.admin.val()

      Alert
        title: "#{count} 件のユーザを更新しますか？"
        message: '選択ミスがないか十分に確認してください。'
        type: 'danger'
        btns: [
          { text: '更新', action: 'update', type: 'danger' }
          { text: 'キャンセル', action: 'close', align: 'right' }
        ]
        callback: (action, al) =>
          if action == 'update'
            UpdateNotify.progress 'ユーザを更新しています...'
            al.close()

            _.each selected, (user) ->
              user.save data,
                success: (model, res) ->
                  ++success
                  notify()
                error: ->
                  ++error
                  notify()

    pageNext: (e) ->
      e.preventDefault()
      Users.hasNext() && Users.getNextPage()

    pagePrev: (e) ->
      e.preventDefault()
      Users.hasPrevious() && Users.getPreviousPage()

    pageFirst: (e) ->
      e.preventDefault()
      Users.getFirstPage()

    pageLast: (e) ->
      e.preventDefault()
      Users.getLastPage()

    pageGoto: (e) ->
      e.preventDefault()
      min = Users.state.firstPage
      max = Users.state.totalPages
      page = @$page.num.val() >>> 0
      page = Math.max min, Math.min(max, page)
      Users.getPage page

    setPerPage: (e) ->
      e.preventDefault()
      Users.setPageSize @$page.size.val() >>> 0

    search: ->
      q = Users.queryParams
      q['search[name]'] = @$search.name.val()
      q['search[admin]'] = @$search.admin.val()

      Users.fetch()

    refresh: ->
      q = Users.queryParams
      q['search[name]'] = null
      q['search[admin]'] = null

      Users.fetch()


  #  Initialize Backbone App
  #-----------------------------------------------
  new AppView()
  new SidebarView()
  new TableView()

