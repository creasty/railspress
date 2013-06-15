
define [
  'jquery'
  'underscore'
  'backbone'
  'app/collections/media'
  'app/views/media/thumb_view'
  'common/notify'
  'common/alert'
  'components/viewstate'
  'components/file_uploader'

  'backbone.syphon'
  'filedrop'
  'masonry'
  'domReady!'
], ($, _, Backbone, Media, ThumbView, Notify, Alert, Viewstate, FileUploader) ->

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
      {}# 'click li': 'onClick'

    initialize: ->
      @listenTo Media, 'add', @addOne
      @listenTo Media, 'reset', @addAll
      @listenTo Media, 'all', @render
      @listenTo Media, 'change', @changeSidebar
      @listenTo Media, 'destroy', @changeSidebar

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
        isAnimated: false
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

    addOne: (medium) ->
      view = new ThumbView model: medium
      $el = view.render().$el
      @$el.prepend($el).masonry 'reload'

    addAll: ->
      @$el.html ''
      Media.each @addOne, @

    disselect: =>
      _.invoke Media.selected(), 'toggle'

    addLoader: (op) ->
      medium = new Media.model
      medium.set op
      Media.add medium

      $el: medium.view.$el
      model: medium

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
          UpdateNotify.success "全 #{count} 件を削除しました"

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

  #  Initialize Backbone App
  #-----------------------------------------------
  App = new AppView()

  #  File uploader
  #-----------------------------------------------
  FileUploader.attachTo $dropzone,
    fileInputSelector: '#medium_asset'

    url: $dropzone.data('post-url') + '.json'

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
    UploaderNotify.progress "メディアをアップロード中... 0/#{total}"
  .on 'onCreate', (e, data, d) ->
    view = App.addLoader
      title:     ''
      file_type: ''
      is_image:  true
      thumbnail: data

    d.$progressbar = view.$el.find '.progressbar > div'
    d.model = view.model
  .on 'eachProgress', (e, percent, d) ->
    d.$progressbar.width percent + '%'
  .on 'eachSuccess', (e, res, d) ->
    d.model.set res
    d.$progressbar.fadeOut()
  .on 'eachError', (e, res, d) ->
    d.model.destroy()
  .on 'uploadProgress', (e, progress, uploaded, total) ->
    UploaderNotify.progress "メディアをアップロード中... #{uploaded} / #{total} 完了"
  .on 'uploadSuccess', (e, total) ->
    UploaderNotify.success "#{total} のメディアをアップロードしました"
  .on 'uploadError', (e, failed, total) ->
    UploaderNotify.fail 'アップロードに失敗しました'

