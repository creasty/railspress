
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
      'click #page_prev': 'pagePrev'
      'click #page_next': 'pageNext'
      'click #btn_update': 'update'
      'click #btn_delete_all': 'deleteAll'
      'click #btn_disselect': 'disselect'

    initialize: ->
      @listenTo Posts, 'change', @changeSidebar
      @listenTo Posts, 'destroy', @changeSidebar

      @$state = @$el.find '> div'
      @$counter = @$state.find 'span.counter'
      Viewstate.attachTo @$state

    changeSidebar: ->
      selected = Posts.selected()
      count = selected.length

      if count > 1
        @$counter.html count
        @$state.trigger 'changeViewstate', 'selecting'
      else
        @$state.trigger 'changeViewstate', 'normal'

    disselect: =>
      _.invoke Posts.selected(), 'toggle'

    deleteAll: =>
      selected = Posts.selected()
      count = selected.length

      success = error = 0

      notify = ->
        return if count < success + error

        if error > 0
          UpdateNotify.fail "メディアの削除に失敗しました (#{error}件)"
        else
          UpdateNotify.success "全 #{count} つのメディアを削除しました"

      Alert
        title: "#{count} 件のメディアを削除しますか？"
        message: '一度削除したメディアはもとに戻すことはできません。'
        type: 'danger'
        btns: [
          { text: '削除', action: 'destroy', type: 'danger' }
          { text: 'キャンセル', action: 'close', align: 'right' }
        ]
        callback: (action, al) =>
          if action == 'destroy'
            UpdateNotify.progress 'メディアを削除しています'
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

    gotoFirst: (e) ->
      e.preventDefault()
      Posts.goTo Posts.information.firstPage

    gotoLast: (e) ->
      e.preventDefault()
      Posts.goTo Posts.information.lastPage

    gotoPage: (e) ->
      e.preventDefault()
      page = $(e.target).text()
      Posts.goTo page

    changeCount: (e) ->
      e.preventDefault()
      per = $(e.target).text()
      Posts.howManyPer per


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

