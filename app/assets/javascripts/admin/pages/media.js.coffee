
require ['jquery', 'utils/isView', 'filedrop', 'masonry'], ($, isView) ->
  return unless isView 'media#index'

  token = $('meta[name="csrf-token"]').attr 'content'

  $main = $ '#main'
  $dropbox = $ '#dropbox'
  $message = $ '.message', $main
  $fileField = $ '#medium_asset'
  $mediaList = $ '#media_list'
  $li = $mediaList.find 'li'

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
          showMessage 'Your browser does not support HTML5 file uploads!'
        when 'TooManyFiles'
          alert 'Too many files! Please select 5 at most! (configurable)'
        when 'FileTooLarge'
          alert file.name + ' is too large! Please upload files up to 2mb (configurable).'

    # Called before each upload is started
    beforeEach: (file) ->
      if !file.type.match /^image\//
        alert 'Only images are allowed!'
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
      # $globalProgress.width progress + '%'

    afterAll: ->


  template =
    """
      <li>
        <div class="preview-image">
          <div class="progressbar">
            <div></div>
          </div>
        </div>
      </li>
    """


  createImage = (file) ->
    $preview = $ template
    $image = $ '.preview-image', $preview

    reader = new FileReader()
    reader.onload = (e) ->
      $image.attr
        style: "background-image: url(#{e.target.result});"

    reader.readAsDataURL file

    $message.hide()
    $preview.width $mediaList.data 'column-width'
    $mediaList.prepend($preview).masonry 'reload'

    $.data file, $preview

  showMessage = (msg) ->
    $message.html msg

