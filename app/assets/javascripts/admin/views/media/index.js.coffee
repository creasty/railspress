
define [
  'jquery'
  'underscore'
  'backbone'
  'app/collections/media'
  'app/views/media/thumb_view'
  'common/notify'
  'common/alert'
  'components/viewstate'

  'backbone.syphon'
  'filedrop'
  'masonry'
  'domReady!'
], ($, _, Backbone, Media, ThumbView, Notify, Alert, Viewstate) ->

  #  Token
  #-----------------------------------------------
  csrf_param = $('meta[name="csrf-param"]').attr 'content'
  csrf_token = $('meta[name="csrf-token"]').attr 'content'

  #  Elements
  #-----------------------------------------------
  $view = $ '#pocket_side > div.view'
  $counter = $view.find 'span.counter'

  $formTitle = $ '#medium_title'
  $formDescription = $ '#medium_description'

  #  Components
  #-----------------------------------------------
  Viewstate.attachTo $view
  UpdateNotify = Notify()
  UploaderNotify = Notify()

  $main = $ '#main'
  $dropzone = $ '#dropzone'
  $fileField = $ '#medium_asset'

  $('#menubar > h1 > a.icon-plus').on 'click', (e) ->
    $fileField.trigger 'click'
    e.preventDefault()


  #  Backbone
  #-----------------------------------------------
  class AppView extends Backbone.View

    el: '#media_list'

    events:
      'click li': 'onClick'

    initialize: ->
      @listenTo Media, 'add', @addOne
      @listenTo Media, 'reset', @addAll
      @listenTo Media, 'all', @render

      $('#btn_update').on 'click', @update
      $('#btn_delete').on 'click', @delete
      $('#btn_delete_all').on 'click', @deleteAll
      $('#btn_disselect').on 'click', @disselect

      Media.fetch()

    render: ->
      @$el.masonry
        itemSelector: 'li'
        gutterWidth: 20
        columns: 5
        minWidth: 170
        isAnimated: true
        isFitWidth: true
        isResizable: true

        columnWidth: do ($el = @$el) -> (cw) ->
          col = Math.max 1, Math.min(@columns, (cw + @gutterWidth) / (@minWidth + @gutterWidth) | 0)
          width = (cw + @gutterWidth) / col - @gutterWidth

          $el.find('li').width width
          width

      @

    changeSidebar: ->
      selected = Media.selected()
      count = selected.length
      console.log selected

      if count > 1
        @$el.addClass 'bulk'
        $counter.html count
        $view.trigger 'changeViewstate', 'bulk'
      else if count == 1
        @$el.removeClass 'bulk'
        $formTitle.val selected[0].get 'title'
        $formDescription.val selected[0].get 'description'
        $view.trigger 'changeViewstate', 'selecting'
      else
        @$el.removeClass 'bulk'
        $view.trigger 'changeViewstate', 'grid'

    onClick: (e) ->
      e.preventDefault()
      @changeSidebar()

    addOne: (medium) ->
      view = new ThumbView model: medium
      @$el.prepend(view.render().$el).masonry 'reload'

    addAll: ->
      @$el.html ''
      Media.each @addOne, @

    newAttributes: ->
      {
        title: @$input.val().trim()
        order: Media.nextOrder()
        completed: false
      }

    disselect: =>
      Media.selected().forEach (medium) ->
        medium.trigger 'toggle'

      @changeSidebar()

    addLoader: (op) ->
      medium = new Media.model
      medium.set op
      Media.models.unshift medium

      $el: @addOne medium
      model: medium

    delete: =>
      selected = Media.selected()

      if selected.length == 1
        medium = selected[0]
        UpdateNotify.progress 'ファイルを削除しています'
        medium.destroy
          success: (model, res) =>
            UpdateNotify.success res.message
            @changeSidebar()

    deleteAll: =>
      selected = Media.selected()
      count = selected.length

      UpdateNotify.progress 'ファイルを削除しています'

      flag = true

      _.invoke selected, 'destroy',
          success: (model, res) -> flag &&= true
          error: -> flag &&= false

      if flag
        UpdateNotify.success '削除しました'
      else
        UpdateNotify.fail '削除に失敗しました'

      @changeSidebar()

    update: ->
      selected = Media.selected()

      if selected.length == 1
        data =
          title: $formTitle.val()
          description: $formDescription.val()

        medium = selected[0]
        medium.save data,
          success: (model, res) ->
            UpdateNotify.success res.message

  App = new AppView()



  $dropzone.filedrop
    fallback_id: 'medium_asset'
    paramname: 'medium[asset]'
    maxfiles: 10
    maxfilesize: 20
    url: $dropzone.data('post-url') + '.json'

    data: do ->
      h = {}
      h[csrf_param] = csrf_token
      h

    docOver: ->
      $main.addClass 'upload'

    docLeave: ->
      $main.removeClass 'upload'

    dragOver: ->
      $main.addClass 'upload'

    dragLeave: ->
      $main.removeClass 'upload'

    drop: ->
      $main.removeClass 'upload'

    error: (err, file) ->
      switch err
        when 'BrowserNotSupported'
          UploaderNotify.fail 'このブラウザではアップロードできません'
        when 'TooManyFiles'
          UploaderNotify.fail '一度にアップロードできるのは10個までです'
        when 'FileTooLarge'
          UploaderNotify.fail "#{file.name} はファイルサイズが大きすぎます"

    # Called before each upload is started
    beforeEach: (file) ->
      if !file.type.match /^image\//
        UploaderNotify.fail "#{file.name} はアップロードできないファイル形式です"
        false
      else
        true

    uploadStarted: (i, file, len) ->
      createImage file

    uploadFinished: (i, file, res) ->
      console.log res
      $.data(file).model.set res
      $.data(file).$el
      .removeClass('progress')
      .find('.progressbar').fadeOut()

    progressUpdated: (i, file, progress) ->
      $.data(file).$el.find('.progressbar > div').width progress + '%'

    globalProgressUpdated: (progress) ->
      UploaderNotify.progress "アップロード中...#{progress}%"

    afterAll: ->
      UploaderNotify.success 'アップロード完了'


  createImage = (file) ->
    reader = new FileReader()

    reader.onload = (e) ->
      $.data file, App.addLoader
        title: null
        file_type: null
        is_image: true
        thumbnail: e.target.result

    reader.readAsDataURL file

