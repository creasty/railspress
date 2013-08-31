require [
  'jquery'
  'underscore'
  'backbone'
  'app/models/post'
  'text!app/templates/posts/thumbnail.html'
  'common/notify'
  'common/alert'
  'common/modal'
  'components/preloader'

  'backbone.syphon'
  'powertip'
  'datepicker'
  'selectize'
  'behave'
  'rangy'
  'domReady!'
], (
  $
  _
  Backbone
  Post
  ThumbnailTemplate
  Notify
  Alert
  Modal
  Preloader
) ->

  #  Componets
  #-----------------------------------------------
  UpdateNotify = Notify()
  Backbone.history.start pushState: true


  #  Model
  #-----------------------------------------------
  Post = new Post()

  #  App View
  #-----------------------------------------------
  class AppView extends Backbone.View

    el: '#post_form'

    events:
      'submit': 'prevent'
      'click #btn_save': 'save'

    initialize: ->
      @load()
      @render()
      @

    load: ->
      id = $('#post_form').data 'id'

      if id?
        id >>>= 0
        model = Backbone.Syphon.serialize(@).post
        model.id = id
        Post.id = id
        Post.set model
        # Post.fetch data: { id }

    refresh: ->
      Backbone.Syphon.deserialize @, post: Post.attributes

    render: -> @

    save: (e) ->
      data = Backbone.Syphon.serialize @

      isSynced = Post.isSynced()

      Post.save data.post,
        success: ->
          if isSynced
            UpdateNotify.success '記事を保存しました'
          else
            window.location.href = Post.get 'edit_link'
            # Backbone.history.navigate Post.get('edit_link'), true
        error: (model, xhr) =>
          Alert
            title: '保存に失敗しました'
            message: $.parseJSON xhr.responseText
            type: 'danger'
            btns: [
              { text: '修正する', action: 'close', type: 'danger' }
              { text: 'もう一度保存する', action: 'retry', type: 'success', align: 'right' }
            ]
            callback: (action, al) =>
              if action == 'retry'
                @save()
                al.close()

    prevent: (e) ->
      e.preventDefault()
      false


  #  Editor View
  #-----------------------------------------------
  class EditorView extends Backbone.View

    el: '#main'

    events:
      'click .menubar .icon-link': 'insertLink'
      'click .menubar .icon-image': 'selectMedia'

      'click .menubar .icon-bold': 'textBold'
      'click .menubar .icon-italic': 'textItalic'
      'click .menubar .icon-underline': 'textUnderline'
      'click .menubar .icon-strike': 'textStrike'
      'click .menubar .icon-quote': 'textQuote'
      'click .menubar .icon-code': 'textCode'

    initialize: ->
      @$textarea = $ '#post_content'
      @textarea = @$textarea.get 0

      new Behave
        textarea:   @textarea
        softTabs:   false
        tabSize:    4
        autoOpen:   true
        overwrite:  true
        autoStrip:  true
        autoIndent: false

      @modal = Modal content: '/admin/media?modal=insert', iframe: true, destroy: true

      $(window).on 'insertMedia', @insertMedia.bind @

      @render()
      # @$el.removeClass 'loader'

    render: -> @

    getSelectionText: ->
      { start, end } = @$textarea.getSelection()
      @$textarea.val()[start...end]

    insertText: (text, repl = false) ->
      { start, end } = @$textarea.getSelection()
      offset = if repl then start else end

      _text = text.replace /[\x02\x03\x0b]/g, ''

      @$textarea.setSelection offset, end
      @$textarea.replaceSelectedText _text

      p = {}
      ch =
        '\x0b': 'cur'
        '\x02': 'begin'
        '\x03': 'end'

      for c, name of ch when ~(idx = text.indexOf c)
        --idx if name == 'end'
        p[name] = offset + idx

      if p.begin && p.end
        @$textarea.setSelection p.begin, p.end
      else if p.cur
        @$textarea.setSelection p.cur, p.cur

    insertLink: (e, txt) ->
      e.preventDefault()
      txt = @getSelectionText()

      repl = "[#{txt}](\x0b)"

      @insertText repl, true

    textBold: (e) ->
      e.preventDefault()
      txt = @getSelectionText()

      repl = "**\x02#{txt}\x03**"

      @insertText repl, true

    textItalic: (e) ->
      e.preventDefault()
      txt = @getSelectionText()
      cur = {}

      repl = "_\x02#{txt}\x03_"

      @insertText repl, true

    textUnderline: (e) ->
      e.preventDefault()
      txt = @getSelectionText()

      repl = "<u>\x02#{txt}\x03</u>"

      @insertText repl, true

    textStrike: (e) ->
      e.preventDefault()
      txt = @getSelectionText()

      repl = "~~\x02#{txt}\x03~~"

      @insertText repl, true

    textQuote: (e) ->
      e.preventDefault()
      txt = @getSelectionText()

      repl = txt.replace /^/mg, '> '

      @insertText repl, true

    textCode: (e) ->
      e.preventDefault()
      txt = @getSelectionText()

      repl =
        if ~txt.indexOf '\n'
          txt.replace /^/mg, '\t'
        else
          "`\x02#{txt}\x03`"

      @insertText repl, true

    selectMedia: (e) ->
      e.preventDefault()
      @modal.open()

    insertMedium: (medium, size, alignment, nl = false) ->
      title = medium.get('title') ? ''
      description = medium.get('description') ? title

      title = _.escape title.replace /\n+/g, ' '
      description = _.escape description.replace /\n+/g, ' '

      if medium.get 'is_image'
        url = medium.get size
        text = "![\x02#{description}\x03](#{url})"
      else
        link = medium.get 'link'
        text = "[#{link}](\x02#{title}\x03)"

      if nl
        text = text.replace /[\x02\x03\x0b]/g, ''
        text += '\n'

      @insertText text

    insertMedia: (e, { media, size, alignment }) ->
      nl = media.length > 1
      _.each media, (medium) =>
        @insertMedium medium, size, alignment, nl

  #  Sidebar View
  #-----------------------------------------------
  class SidebarView extends Backbone.View

    el: '#pocket_side'

    events:
      'scroll': 'hideDatepicker'
      'click #btn_delete': 'destroy'
      'click #post_thumbnail .icon-image': 'selectThumbnail'
      'click #post_thumbnail .icon-plus': 'selectThumbnail'
      'click #post_thumbnail .icon-ban': 'clearThumbnail'

    initialize: ->
      @$form =
        date:        $ '#post_date_str'
        tags:        $ '#post_tag_list'
        thumbnail:   $ '#post_thumbnail'
        thumbnailId: $ '#post_thumbnail_id'

      $(window).on 'setThumbnail', @setThumbnail.bind @

      @modal = Modal content: '/admin/media?modal=thumbnail', iframe: true, destroy: true

      @thumbnailTemplate = _.template ThumbnailTemplate

      @render()

    hideDatepicker: ->
      @$form.date.datepicker 'hide'

    render: ->
      @$form.date.datepicker format: 'yyyy.mm.dd'

      @$form.thumbnail.html @thumbnailTemplate thumbnail: @$form.thumbnail.data 'thumbnail'

      Preloader.attachTo @$form.thumbnail.find 'img'

      $.ajax
        url: "#{Post.urlRoot}/tags"
        format: 'json'
        success: (tags) =>
          @$form.tags.selectize
            plugins: ['remove_button']
            delimiter: ', '
            persist: false
            valueField: 'value'
            labelField: 'text'
            searchField: ['text']
            options: tags
            create: (input) -> { value: input, text: input }

      @

    destroy: ->
      Alert
        title: "記事を削除しますか？"
        message: '一度削除するともとに戻すことはできません。'
        type: 'danger'
        btns: [
          { text: '削除', action: 'destroy', type: 'danger' }
          { text: 'キャンセル', action: 'close', align: 'right' }
        ]
        callback: (action, al) =>
          if action == 'destroy'
            UpdateNotify.progress '記事を削除しています...'
            al.close()

            Post.destroy
              success: ->
                window.location.href = Post.urlRoot
              error: ->
                UpdateNotify.fail '記事の削除に失敗しました'

    selectThumbnail: ->
      @modal.open()

    setThumbnail: (e, { medium }) ->
      @$form.thumbnailId.val medium.get 'id'
      @$form.thumbnail.html @thumbnailTemplate medium.toJSON()

    clearThumbnail: ->
      @$form.thumbnailId.val null
      @$form.thumbnail.html @thumbnailTemplate thumbnail: false


  #  Initialize Backbone App
  #-----------------------------------------------
  new AppView()
  new EditorView()
  new SidebarView()
