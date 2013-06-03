
define [
  'jquery'
  'common/notify'
  'components/viewstate'
  'components/select'
  'utils/template'
  'text!./item.tpl'
  'filedrop'
  'masonry'
], ($, Notify, Viewstate, Select, template, item_html) ->

  #  Token
  #-----------------------------------------------
  token = $('meta[name="csrf-token"]').attr 'content'

  #  Elements
  #-----------------------------------------------
  $mediaList = $ '#media_list'
  $li = $mediaList.find 'li'

  $view = $ '#pocket_side > form > div.view'
  $counter = $view.find 'span.counter'

  #  Components
  #-----------------------------------------------
  Viewstate.attachTo $view
  Select.attachTo $mediaList, itemSelector: '> li'

  #  Media List
  #-----------------------------------------------
  $mediaList.on 'select', (e, count) ->
    if count > 1
      $mediaList.addClass 'bulk'
      $counter.html count
      $view.trigger 'changeViewstate', 'bulk'
    else if count == 1
      $mediaList.removeClass 'bulk'
      $view.trigger 'changeViewstate', 'selecting'
    else
      $mediaList.removeClass 'bulk'
      $view.trigger 'changeViewstate', 'grid'

  #  Grid
  #-----------------------------------------------
  $mediaList.masonry
    itemSelector: 'li'
    gutterWidth: 20
    columns: 5
    minWidth: 170
    isAnimated: true
    isFitWidth: true
    isResizable: true

    columnWidth: (cw) ->
      col = Math.max 1, Math.min(@columns, (cw + @gutterWidth) / (@minWidth + @gutterWidth) | 0)
      width = (cw + @gutterWidth) / col - @gutterWidth

      $mediaList.data 'column-width', width
      $li.width width
      width

  #  File Uploader
  #-----------------------------------------------
  notifi_uploader = Notify()

  $main = $ '#main'
  $dropbox = $ '#dropbox'
  $fileField = $ '#medium_asset'

  ItemTmpl = template item_html

  $('#menubar > h1 > a.icon-plus').on 'click', (e) ->
    $fileField.trigger 'click'
    e.preventDefault()

  $dropbox.filedrop
    fallback_id: 'medium_asset'
    paramname: 'medium[asset]'
    maxfiles: 10
    maxfilesize: 20
    url: $dropbox.data 'post-url'
    data:
      authenticity_token: token

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
          notifi_uploader.fail 'このブラウザではアップロードできません'
        when 'TooManyFiles'
          notifi_uploader.fail '一度にアップロードできるのは10個までです'
        when 'FileTooLarge'
          notifi_uploader.fail "#{file.name} はファイルサイズが大きすぎます"

    # Called before each upload is started
    beforeEach: (file) ->
      if !file.type.match /^image\//
        notifi_uploader.fail "#{file.name} はアップロードできないファイル形式です"
        false
      else
        true

    uploadStarted: (i, file, len) ->
      createImage file

    uploadFinished: (i, file, response) ->
      $.data(file).addClass 'done'
      $.data(file).find('.progressbar').fadeOut()

    progressUpdated: (i, file, progress) ->
      $.data(file).find('.progressbar > div').width progress + '%'

    globalProgressUpdated: (progress) ->
      notifi_uploader.progress "アップロード中...#{progress}%"

    afterAll: ->
      notifi_uploader.success 'アップロード完了'


  createImage = (file) ->
    $preview = $ """
        <li>
          <div class="preview-image">
            <div class="progressbar">
              <div></div>
            </div>
          </div>
        </li>
      """

    $image = $ '.preview-image', $preview

    reader = new FileReader()
    reader.onload = (e) ->
      $image.attr # .css() won't work!
        style: "background-image: url(#{e.target.result});"

    reader.readAsDataURL file

    $preview.width $mediaList.data 'column-width'
    $mediaList.prepend($preview).masonry 'reload'

    $.data file, $preview

  #  Delete
  #-----------------------------------------------
  notifi_delete = Notify()

  $(document)
  .on 'ajax:beforeSend', '#media_list a[data-method="delete"]', ->
    notifi_delete.progress 'ファイルを削除しています'
  .on 'ajax:success', '#media_list a[data-method="delete"]', (e, res) ->
    if res.success
      $medium = $ '#medium_' + res.id

      notifi_delete.success res.msg
      $mediaList.masonry('remove', $medium).masonry 'reload'

