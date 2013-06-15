
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

      UpdateNotify.progress 'ファイルを削除しています'

      selected[0].destroy
        success: do (that = @) -> (model, res) ->
          UpdateNotify.success res.message

    deleteAll: =>
      selected = Media.selected()
      count = selected.length

      UpdateNotify.progress 'ファイルを削除しています'

      success = error = 0

      notify = ->
        return if count < success + error

        if error > 0
          UpdateNotify.fail "メディアの削除に失敗しました (#{error}件)"
        else
          UpdateNotify.success "全 #{count} 件を削除しました"

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
  $(document)
  .on 'dragover', (e) ->
    e.preventDefault()
    $main.addClass 'upload'
    false
  .on 'dragleave', (e) ->
    e.preventDefault()
    return false unless window.event.pageX == 0 || window.event.pageY == 0
    $main.removeClass 'upload'
    false
  .on 'drop', (e) ->
    e.preventDefault()
    $main.removeClass 'upload'
    false

  $dropzone.on 'drop', (e) ->
    e.preventDefault()
    $main.removeClass 'upload'
    files = e.originalEvent.dataTransfer.files
    _.each files, (file) -> uploadFile file
    false

  $('#medium_asset').on 'change', (e) ->
    e.preventDefault()
    _.each @files, (file) -> uploadFile file

  uploadFile = (file) ->
    reader = new FileReader()
    form = new FormData()

    percent = 0

    $progressbar = null
    model = null

    reader.onload = (e) ->
      form.append 'csrf_param', csrf_token
      form.append 'medium[asset]', file
      form.append 'medium[content_type]', file.type
      form.append 'medium[file_name]', file.name

      view = App.addLoader
        title:     ''
        file_type: ''
        is_image:  true
        thumbnail: e.target.result

      $progressbar = view.$el.find '.progressbar > div'
      model = view.model

    reader.onloadend = ->
      $.ajax
        url: $dropzone.data('post-url') + '.json'
        dataType: 'json'
        data: form
        cache: false
        contentType: false
        processData: false
        type: 'post'

        xhr: ->
          xhr = $.ajaxSettings.xhr()

          xhr.upload.addEventListener 'progress', progressHandler, false

          xhr.addEventListener 'progress', progressHandler, false

          xhr

        success: (data) ->
          model.set data
          $progressbar.fadeOut()

        error: ->
          model.destroy()
          UploaderNotify.fail 'アップロードに失敗しました'

    progressHandler = (e) ->
      if e.lengthComputable
        percent = 100 * e.loaded / e.total / 2
        $progressbar.width percent + '%'

    reader.readAsDataURL file

