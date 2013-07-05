require [
  'jquery'
  'underscore'
  'backbone'
  'app/models/post'
  'text!app/templates/posts/thumbnail.html'
  'common/notify'
  'common/alert'
  'common/modal'
  'ace/ace'

  'backbone.syphon'
  'powertip'
  'datepicker'
  'selectize'
  'ace/theme/solarized_light'
  'ace/mode/html'
  'ace/mode/markdown'
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
  ACE
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
      'click #editor_mode_md': 'switchToMarkdown'
      'click #editor_mode_html': 'switchToHtml'

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
      @editor = ACE.edit 'post_content_ace'
      @session = @editor.getSession()

      @$mode =
        markdown: $ '#editor_mode_md'
        html: $ '#editor_mode_html'

      @modal = Modal content: '/admin/media?modal=insert', iframe: true, destroy: true

      $(window).on 'insertMedia', @insertMedia.bind @

      @render()
      @$el.addClass 'loaded'

    setMode: (mode) ->
      return if mode == @mode
      @mode = mode
      @session.setMode "ace/mode/#{@mode}"
      @$mode.markdown.removeClass 'selected'
      @$mode.html.removeClass 'selected'
      @$mode[@mode].addClass 'selected'

    render: ->
      @editor.setTheme 'ace/theme/solarized_light'
      @setMode 'html'
      @session.setTabSize 2
      @session.setUseWrapMode true
      @session.setValue @$textarea.val()

      @session.on 'change', =>
        @$textarea.val @session.getValue()

      @editor.setShowPrintMargin false
      @editor.focus()

      @editor.commands.addCommand
        name: 'Save'
        bindKey:
          win: 'Ctrl-S'
          mac: 'Command-S'
        readOnly: false
        exec: (editor) -> Post.save()

      @

    switchToHtml: (e) ->
      e.preventDefault()
      @setMode 'html'
      Notify().info 'HTML モードに切り替えました'

    switchToMarkdown: (e) ->
      e.preventDefault()
      @setMode 'markdown'
      Notify().info 'Markdown モードに切り替えました'

    getSelectionText: ->
      ran = @editor.getSelection().getRange()
      @session.getTextRange ran

    insertAndMoveCursor: (start, text) ->
      @session.insert start, text.replace /[\x02\x03\x0b]/g, ''

      { row, column } = start
      p = {}
      ch =
        '\x0b': 'cur'
        '\x02': 'begin'
        '\x03': 'end'

      text.split('\n').forEach (t, i) ->
        col = column
        for c, name of ch
          idx = t.indexOf c
          if idx >= 0
            p[name] = [row + i, col + idx]
            --col if name == 'begin'

      if p.begin && p.end
        @editor.moveCursorTo p.begin...
        @editor.clearSelection()
        @editor.selection.selectTo p.end...
      else if p.cur
        @editor.moveCursorTo p.cur...
        @editor.clearSelection()

    insertText: (text) ->
      ran = @editor.getSelection().getRange()
      @insertAndMoveCursor ran.start, text
      @editor.focus()

    replaceSelection: (text) ->
      ran = @editor.getSelection().getRange()
      @session.remove ran
      @insertAndMoveCursor ran.start, text
      @editor.focus()

    insertLink: (e, txt) ->
      e.preventDefault()
      txt = @getSelectionText()

      repl =
        if 'html' == @mode
          "<a href=\"\">\x02#{txt}\x03</a>"
        else
          "[#{txt}](\x0b)"

      @replaceSelection repl

    textBold: (e) ->
      e.preventDefault()
      txt = @getSelectionText()

      repl =
        if 'html' == @mode
          "<strong>\x02#{txt}\x03</strong>"
        else
          "**\x02#{txt}\x03**"

      @replaceSelection repl

    textItalic: (e) ->
      e.preventDefault()
      txt = @getSelectionText()
      cur = {}

      repl =
        if 'html' == @mode
          "<em>\x02#{txt}\x03</em>"
        else
          "_\x02#{txt}\x03_"

      @replaceSelection repl

    textUnderline: (e) ->
      e.preventDefault()
      txt = @getSelectionText()

      repl = "<u>\x02#{txt}\x03</u>"

      @replaceSelection repl

    textStrike: (e) ->
      e.preventDefault()
      txt = @getSelectionText()

      repl =
        if 'html' == @mode
          "<del>\x02#{txt}\x03</del>"
        else
          "~~\x02#{txt}\x03~~"

      @replaceSelection repl

    textQuote: (e) ->
      e.preventDefault()
      txt = @getSelectionText()

      repl =
        if 'html' == @mode
          """
          <blockquote>
          \x02#{txt.replace(/^/mg, '\t')}\x03
          </blockquote>
          """
        else
          txt.replace /^/mg, '> '

      @replaceSelection repl

    textCode: (e) ->
      e.preventDefault()
      txt = @getSelectionText()

      repl =
        if 'html' == @mode
          if txt.indexOf('\n') >= 0
            """
            <pre><code>
            \x02#{txt}\x03
            </code></pre>
            """
          else
            "<code>\x02#{txt}\x03</code>"
        else
          if txt.indexOf('\n') >= 0
            txt.replace /^/mg, '\t'
          else
            "`\x02#{txt}\x03`"

      @replaceSelection repl

    selectMedia: (e) ->
      e.preventDefault()
      @modal.open()

    insertMedium: (medium, size, alignment, nl = false) ->
      title = medium.get('title') ? ''
      description = medium.get('description') ? title

      title = _.escape title.replace /\n/, ' '
      description = _.escape description.replace /\n/, ' '

      if medium.get 'is_image'
        url = medium.get size
        text =
          if @mode == 'html'
            "<img src=\"#{url}\" alt=\"\x02#{description}\x03\" class=\"align-#{alignment}\" />"
          else
            "![\x02#{description}\x03](#{url})"
      else
        link = medium.get 'link'
        text =
          if 'html' == @mode
            "<a href=\"#{link}\">\x02#{title}\x03</a>"
          else
            "[#{link}](\x02#{title}\x03)"

      if nl
        text = text.replace /[\x02\x03\x0b]/g, ''
        text += '\n'

      @insertText text

    insertMedia: (e, { media, size, alignment }) ->
      if media.length > 1
        _.each media, (medium) =>
          @insertMedium medium, size, alignment, true
      else
        @insertMedium media[0], size, alignment


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
