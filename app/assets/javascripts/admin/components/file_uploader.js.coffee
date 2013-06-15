
define [
  'jquery',
  'flight/lib/component'
], ($, defineComponent) ->

  csrf_param = $('meta[name="csrf-param"]').attr 'content'
  csrf_token = $('meta[name="csrf-token"]').attr 'content'

  class Uploader

    constructor: (@c, @files) ->
      @total = @files.length

      @progress = 0
      @success = 0
      @error = 0
      @data = {}

      @startUpload()

    startUpload: ->
      @c.trigger 'startUploading', @total
      @uploadFile @files[i], i for i in [0...@total] by 1

    create: (e, file, form, i) ->
      form.append csrf_param, csrf_token
      form.append @c.attr.params.file, file
      form.append @c.attr.params.type, file.type
      form.append @c.attr.params.name, file.name

      @data[i] =
        progress: 0
        res: null
        data: e.target.result
        fileType: file.type
        fileName: file.name

      @c.trigger 'onCreate', [@data[i].data, @data[i]]

    postData: (form, i) ->
      $.ajax
        url: @c.attr.url
        dataType: 'json'
        data: form
        cache: false
        contentType: false
        processData: false
        type: 'post'

        xhr: =>
          xhr = $.ajaxSettings.xhr()

          xhr.upload.addEventListener 'progress', (e) =>
            @uploadProgress e, i
          , false

          xhr.addEventListener 'progress', (e) =>
            @uploadProgress e, i
          , false

          xhr

        success: (res) =>
          @data[i].res = res
          @data[i].progress = 100
          @c.trigger 'eachSuccess', [res, @data[i]]
          ++@success
          @globalProgress()

        error: (res) =>
          @data[i].res = res
          @data[i].progress = 100
          @c.trigger 'eachError', [res, @data[i]]
          ++@error
          @globalProgress()

    uploadProgress: (e, i) ->
      if e.lengthComputable
        progress = (100 * e.loaded / e.total) | 0
        @data[i].progress = progress
        @c.trigger 'eachProgress', [progress, @data[i]]
        @globalProgress()

    globalProgress: ->
      if @total == @success + @error
        if @error > 0
          @c.trigger 'uploadError', [@error, @total]
        else
          @c.trigger 'uploadSuccess', @total
      else
        p = 0
        p += d.progress for d in @data
        @progress = (p / @total) | 0
        @c.trigger 'uploadProgress', [@progress, @success, @total]

    uploadFile: (file, i) ->
      reader = new FileReader()
      form = new FormData()

      reader.onload = (e) =>
        @create e, file, form, i

      reader.onloadend = =>
        @postData form, i

      reader.readAsDataURL file


  defineComponent ->

    @defaultAttrs
      url: ''
      params: {}
      fileInputSelector: false

    @docDropper = ->
      $(document)
      .on 'dragover', (e) =>
        e.preventDefault()
        @trigger 'fileDragOver'
        false
      .on 'dragleave', (e) =>
        e.preventDefault()
        return false unless window.event.pageX == 0 || window.event.pageY == 0
        @trigger 'fileDragOver'
        false
      .on 'drop', (e) =>
        e.preventDefault()
        @trigger 'fileDropped'
        false

    @zoneDropper = (e) ->
      e.preventDefault()
      @trigger 'fileDropped'
      @startUpload e.originalEvent.dataTransfer.files
      false

    @clickable = (e) ->
      e.preventDefault()
      @startUpload e.target.files

    @startUpload = (files) ->
      new Uploader @, files

    @after 'initialize', ->
      @docDropper()

      @on 'drop', @zoneDropper

      if @attr.fileInputSelector
        @on 'change', fileInputSelector: @clickable



