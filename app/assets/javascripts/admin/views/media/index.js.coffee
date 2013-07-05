
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
  'easing'
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

  #  Components
  #-----------------------------------------------
  UpdateNotify = Notify()
  UploaderNotify = Notify()

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

      @listenTo Media, 'addLoader', @addLoader

      @$main = $ '#main'
      @$pocketBody = $ '#pocket_body'

      @$pocketBody.on 'scroll', @loadMore.bind(@)

      Media.fetch
        success: =>
          @$main.addClass 'loaded'
          @loadMore()

    render: ->
      @$el.masonry
        itemSelector: 'li'
        gutterWidth: 20
        columns: 5
        minWidth: 150
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
      if medium.get('id')?
        @$el.append($el.addClass('appended')).masonry 'reload'
      else
        @$el.prepend($el).masonry 'reload'

    addAll: (_, ob) ->
      Media.each @addOne, @
      Media.add ob.previousModels, at: 0, silent: true

    addLoader: (op, callback) ->
      medium = new Media.model
      medium.set op
      Media.add medium

      callback && callback
        $el: medium.view.$el
        model: medium

    toggle: (e) ->
      $t = $ e.currentTarget
      model = $t.data 'model'

      if !e.shiftKey || window.MODAL_NAME == 'thumbnail'
        Media.selected().forEach (medium) ->
          medium.toggle() if medium.id != model.id

      model.toggle()

    loadMore: ->
      buffer = 200

      bottomOfViewport = @$pocketBody.scrollTop() + @$pocketBody.height()

      bottomOfCollectionView = @$el.offset().top + @$el.height() - buffer

      if Media.hasNext() && !@isLoading && bottomOfViewport > bottomOfCollectionView

        @isLoading = true

        Media.getNextPage
          remove: false
          update: true
          success: =>
            @isLoading = false


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

      @$view = $ '#pocket_side > div'
      @$counter = @$view.find 'span.counter'
      Viewstate.attachTo @$view

      @$displayOption = $ '#display_option'

      @$btn =
        crop: $ '#btn_crop'
        link: $ '#btn_link'

      @$form =
        title: $ '#medium_title'
        description: $ '#medium_description'
        size: $ '#medium_size'
        alignment: $ '#medium_alignment'

    changeSidebar: ->
      selected = Media.selected()
      count = selected.length

      if count > 1
        @$counter.html count
        @$view.trigger 'changeViewstate', 'bulk'
      else if count == 1
        @$form.title.val selected[0].get 'title'
        @$form.description.val selected[0].get 'description'
        @$btn.link.attr 'href', selected[0].get 'link'

        if selected[0].get 'is_image'
          @$displayOption.show()
          @$btn.crop.show().data 'model', selected[0]
        else
          @$displayOption.hide()
          @$btn.crop.hide().data 'model', null

        @$view.trigger 'changeViewstate', 'selecting'
      else
        @$view.trigger 'changeViewstate', 'grid'

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
        return if count > success + error

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
          title: @$form.title.val()
          description: @$form.description.val()

        medium = selected[0]
        medium.save data,
          success: (model, res) ->
            UpdateNotify.success res.message

  #  Modal
  #-----------------------------------------------
  class ImageEditorView extends Backbone.View

    el: '#edit_medium'

    events:
      'modalOpen': 'open'
      'modalClose': 'close'

    initialize: ->
      @coords = {}
      @modal = Modal content: @$el

      @$cropbox = $ '#cropbox'
      @$btn_crop = $ '#btn_crop'
      @$btn_crop.on 'click', @openModal.bind(@)

    openModal: (e) ->
      e.preventDefault()
      @modal.open()

    open: ->
      @model = @$btn_crop.data 'model'
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


  #  File Uploader
  #-----------------------------------------------
  class FileUploaderView extends Backbone.View

    el: '#dropzone'

    events:
      'fileDragOver': 'over'
      'fileDragLeave': 'leave'
      'fileDropped': 'leave'

      'startUploading': 'startUploading'
      'onCreate': 'onCreate'
      'eachSuccess': 'eachSuccess'
      'eachError': 'eachError'
      'uploadProgress': 'uploadProgress'
      'uploadSuccess': 'uploadSuccess'
      'uploadError': 'uploadError'

    initialize: ->
      @$main = $ '#main'
      @$fileField = $ '#medium_asset'
      @$btnAdd = $ '#menubar > h1 > a.icon-plus'

      FileUploader.attachTo @$el,
        fileInputSelector: '#medium_asset'

        url: '/admin/media.json'

        params:
          file: 'medium[asset]'
          type: 'medium[content_type]'
          name: 'medium[file_name]'

      @$btnAdd.on 'click', (e) =>
        e.preventDefault()
        @addNew()

    addNew: ->
      @$fileField.trigger 'click'

    over: ->
      @$main.addClass 'upload'

    leave: ->
      @$main.removeClass 'upload'

    startUploading: (e, total) ->
      UploaderNotify.progress "#{total} つのメディアをアップロード中..."

    onCreate: (e, data, d) ->
      Media.trigger 'addLoader',
        {
          title:     d.fileName
          file_type: d.fileType
          is_image:  d.fileType.split('/')[0] == 'image'
          small:     data
          loading:   true
        },
        (view) ->
          d.loader = view.$preview.addClass 'loading'
          d.model = view.model

    eachSuccess: (e, res, d) ->
      d.loader.removeClass 'loading'
      d.model.set res

    eachError: (e, res, d) ->
      d.model.destroy()

    uploadProgress: (e, progress, uploaded, total) ->
      UploaderNotify.progress "メディアをアップロード中... #{uploaded} / #{total} 完了"

    uploadSuccess: (e, total) ->
      UploaderNotify.success "#{total} つのメディアをアップロードしました"

    uploadError: (e, failed, total) ->
      UploaderNotify.fail 'アップロードに失敗しました'


  #  Modal
  #-----------------------------------------------
  class ModalView extends Backbone.View

    el: '#modal_container'

    events:
      'click #modal_btn_thumbnail': 'setThumbnail'
      'click #modal_btn_insert': 'insert'

    initialize: ->
      @listenTo Media, 'change:selected', @update

      @wp = window.parent
      @$wp = @wp.$ @wp
      @name = window.name
      @$images = {}

      @$preview = $ '#footer_preview'
      @$pocketBody = $ '#pocket_body'

      @$form =
        medium_size: $ '#medium_size'
        medium_alignment: $ '#medium_alignment'
        bulk_size: $ '#bulk_size'
        bulk_alignment: $ '#bulk_alignment'

    closeModal: ->
      @$wp.trigger 'closeModal', @name

    setThumbnail: ->
      sel = Media.selected()

      if sel.length == 1
        @$wp.trigger 'setThumbnail', medium: sel[0]

      @closeModal()

    insert: ->
      sel = Media.selected()

      if sel.length == 1
        @$wp.trigger 'insertMedia',
          media: sel
          size: @$form.medium_size.val()
          alignment: @$form.medium_alignment.val()
      else if sel.length > 1
        @$wp.trigger 'insertMedia',
          media: sel
          size: @$form.bulk_size.val()
          alignment: @$form.bulk_alignment.val()

      @closeModal()

    update: ->
      now = []

      _.each Media.selected(), (medium) =>
        id = medium.get 'id'
        now.push id

        unless @$images[id]
          src = medium.get 'small'
          $el = medium.view.$el

          $img = $ "<figure style=\"background-image: url(#{src})\"></figure>"

          $img.on 'click', =>
            offset = -80 + @$pocketBody.scrollTop()

            @$pocketBody
            .stop()
            .animate
              scrollTop: offset + $el.offset().top
              duration: 600
              easing: 'easeInCubic'

          @$images[id] = $img

      _.each _.without(@prev, now...), (id) =>
        @$images[id].detach()

      _.each _.difference(now, @prev), (id) =>
        @$images[id].prependTo @$preview

      @prev = now


  #  Initialize Backbone App
  #-----------------------------------------------
  new AppView()
  new SidebarView()
  new ImageEditorView()
  new FileUploaderView()
  new ModalView()

