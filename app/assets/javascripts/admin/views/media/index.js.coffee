
define [
  'jquery'
  'underscore'
  'backbone'
  'app/collections/media'
  'app/views/media/thumb_view'
  'common/notify'
  'common/alert'
  'common/modal'
  'components/viewstate'
  'components/file_uploader'

  'backbone.syphon'
  'masonry'
  'jcrop'
  'domReady!'
], (
  $
  _
  Backbone
  Media
  ThumbView
  Notify
  Alert
  Modal
  Viewstate
  FileUploader
) ->

  #  Token
  #-----------------------------------------------
  csrf_param = $('meta[name="csrf-param"]').attr 'content'
  csrf_token = $('meta[name="csrf-token"]').attr 'content'

  #  Elements
  #-----------------------------------------------
  $view = $ '#pocket_side > div'
  $counter = $view.find 'span.counter'

  $formTitle = $ '#medium_title'
  $formDescription = $ '#medium_description'
  $formLink = $ '#medium_link'
  $btn_crop = $ '#btn_crop'

  #  Components
  #-----------------------------------------------
  Viewstate.attachTo $view
  UpdateNotify = Notify()
  UploaderNotify = Notify()

  $main = $ '#main'
  $dropzone = $ '#dropzone'
  $fileField = $ '#medium_asset'

  #  Sidebar
  #-----------------------------------------------
  class SidebarView extends Backbone.View

    el: '#pocket_side'

    events:
      'click #btn_update': 'update'
      'click #btn_delete': 'delete'
      'click #btn_delete_all': 'deleteAll'
      'click #btn_disselect': 'disselect'

    initialize: ->
      @listenTo Media, 'change', @changeSidebar
      @listenTo Media, 'destroy', @changeSidebar

    changeSidebar: ->
      selected = Media.selected()
      count = selected.length

      if count > 1
        $counter.html count
        $view.trigger 'changeViewstate', 'bulk'
      else if count == 1
        $formTitle.val selected[0].get 'title'
        $formDescription.val selected[0].get 'description'
        $formLink.attr 'href', selected[0].get 'link'

        if selected[0].get 'is_image'
          $btn_crop.show().data 'model', selected[0]
        else
          $btn_crop.hide().data 'model', null

        $view.trigger 'changeViewstate', 'selecting'
      else
        $view.trigger 'changeViewstate', 'grid'

    disselect: =>
      _.invoke Media.selected(), 'toggle'

    delete: =>
      selected = Media.selected()

      return unless selected.length == 1

      Alert
        title: 'このメディアを削除しますか？'
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

            selected[0].destroy
              success: (model, res) ->
                UpdateNotify.success res.message

    deleteAll: =>
      selected = Media.selected()
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
      selected = Media.selected()

      if selected.length == 1
        data =
          title: $formTitle.val()
          description: $formDescription.val()

        medium = selected[0]
        medium.save data,
          success: (model, res) ->
            UpdateNotify.success res.message

  #  App View
  #-----------------------------------------------
  class AppView extends Backbone.View

    el: '#media_list'

    events:
      'click li': 'toggle'

    initialize: ->
      @listenTo Media, 'add', @addOne
      @listenTo Media, 'reset', @addAll
      @listenTo Media, 'all', @render
      @listenTo Media, 'change', @bulk

      Media.fetch
        success: ->
          $main.removeClass 'loaded'

    render: ->
      @$el.masonry
        itemSelector: 'li'
        gutterWidth: 20
        columns: 5
        minWidth: 170
        isAnimated: false
        isFitWidth: true
        isResizable: true

        columnWidth: do ($el = @$el) -> (cw) ->
          col = Math.max 1, Math.min(@columns, (cw + @gutterWidth) / (@minWidth + @gutterWidth) | 0)
          width = (cw + @gutterWidth) / col - @gutterWidth

          $el.find('li').width width
          width

      @

    bulk: ->
      count = Media.selected().length

      if count > 1
        @$el.addClass 'bulk'
      else
        @$el.removeClass 'bulk'

    addOne: (medium) ->
      view = new ThumbView model: medium
      $el = view.render().$el
      @$el.prepend($el).masonry 'reload'

    addAll: ->
      @$el.html ''
      Media.each @addOne, @

    addLoader: (op) ->
      medium = new Media.model
      medium.set op
      Media.add medium

      $el: medium.view.$el
      model: medium

    toggle: (e) ->
      $t = $ e.currentTarget
      model = $t.data 'model'

      unless e.shiftKey
        Media.selected().forEach (medium) ->
          medium.toggle() if medium.id != model.id

      model.toggle()

  #  Modal
  #-----------------------------------------------
  class ImageEditorView extends Backbone.View

    el: '#edit_medium'

    events:
      'modalOpen': 'open'
      'modalClose': 'close'

    initialize: ->
      @coords = {}
      @$cropbox = $ '#cropbox'

      @modal = Modal content: @$el

      $btn_crop.on 'click', @openModal.bind(@)

    openModal: (e) ->
      e.preventDefault()
      @modal.open()

    open: ->
      @model = $btn_crop.data 'model'
      src = @model.get 'link'

      @coords = [
        @model.get 'crop_x'
        @model.get 'crop_y'
        @model.get 'crop_w'
        @model.get 'crop_h'
      ]
      @prev = @coords.join ':'

      @$el.addClass 'loading'

      img = new Image()
      img.src = src
      img.onload = =>
        $image = $ "<img src=\"#{src}\" alt=\"\" />"

        $image.appendTo @$cropbox

        $image.Jcrop
          onChange: (coords) => @updateCrop coords
          onSelect: (coords) => @updateCrop coords
          setSelect: @getSelection()
          # aspectRatio: 1

        @$el.removeClass 'loading'

    close: ->
      if @prev != @coords.join ':'
        notify = Notify()

        notify.progress '画像を切り抜いています...'

        @model.save
          crop_x: @coords[0]
          crop_y: @coords[1]
          crop_w: @coords[2]
          crop_h: @coords[3]
        ,
          success: ->
            notify.success '画像の切り抜き処理が完了しました'
          error: ->
            notify.fail '画像の切り抜きに失敗しました'

      @$cropbox.html ''

    updateCrop: (coords) ->
      @coords = [coords.x, coords.y, coords.w, coords.h]

    getSelection: ->
      x = parseInt @coords[0], 10
      y = parseInt @coords[1], 10
      w = parseInt @coords[2], 10
      h = parseInt @coords[3], 10

      return if isNaN x + y + w + h

      [x, y, x + w, y + h]


  #  Initialize Backbone App
  #-----------------------------------------------
  AppView = new AppView()
  SidebarView = new SidebarView()
  ImageEditorView = new ImageEditorView()


  #  File uploader
  #-----------------------------------------------
  $('#menubar > h1 > a.icon-plus').on 'click', (e) ->
    $fileField.trigger 'click'
    e.preventDefault()

  FileUploader.attachTo $dropzone,
    fileInputSelector: '#medium_asset'

    url: '/admin/media.json'

    params:
      file: 'medium[asset]'
      type: 'medium[content_type]'
      name: 'medium[file_name]'

  $dropzone
  .on 'fileDragOver', ->
    $main.addClass 'upload'
  .on 'fileDragLeave fileDropped', ->
    $main.removeClass 'upload'
  .on 'startUploading', (e, total) ->
    UploaderNotify.progress "#{total} つのメディアをアップロード中..."
  .on 'onCreate', (e, data, d) ->
    view = AppView.addLoader
      title:     d.fileName
      file_type: d.fileType
      is_image:  d.fileType.split('/')[0] == 'image'
      thumbnail: data
      loading:   true

    d.loader = view.$el.find('.preview-image').addClass 'loading'
    d.model = view.model
  .on 'eachSuccess', (e, res, d) ->
    d.loader.removeClass 'loading'
    d.model.set res
  .on 'eachError', (e, res, d) ->
    d.model.destroy()
  .on 'uploadProgress', (e, progress, uploaded, total) ->
    UploaderNotify.progress "メディアをアップロード中... #{uploaded} / #{total} 完了"
  .on 'uploadSuccess', (e, total) ->
    UploaderNotify.success "#{total} つのメディアをアップロードしました"
  .on 'uploadError', (e, failed, total) ->
    UploaderNotify.fail 'アップロードに失敗しました'

