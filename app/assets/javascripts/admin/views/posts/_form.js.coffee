require [
  'jquery'
  'underscore'
  'backbone'
  'app/models/post'
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
      'click .menubar .icon-image': 'insertMedia'

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

    switchToMarkdown: (e) ->
      e.preventDefault()
      @setMode 'markdown'

    getSelectionText: ->
      ran = @editor.getSelection().getRange()
      @session.getTextRange ran

    insertText: (text) ->
      ran = @editor.getSelection().getRange()
      @session.insert ran.start, text
      @editor.focus()

    replaceSelection: (text) ->
      ran = @editor.getSelection().getRange()
      @session.remove ran
      @session.insert ran.start, text
      @editor.focus()

    insertLink: (e) ->
      e.preventDefault()
      txt = @getSelectionText()

      repl =
        if 'html' == @mode
          "<a href=\"\">#{txt}</a>"
        else
          "[#{txt}]()"

      @replaceSelection repl

    insertMedia: (e) ->
      e.preventDefault()

    textBold: (e) ->
      e.preventDefault()
      txt = @getSelectionText()

      repl =
        if 'html' == @mode
          "<strong>#{txt}</strong>"
        else
          "**#{txt}**"

      @replaceSelection repl

    textItalic: (e) ->
      e.preventDefault()
      txt = @getSelectionText()

      repl =
        if 'html' == @mode
          "<em>#{txt}</em>"
        else
          "_#{txt}_"

      @replaceSelection repl

    textUnderline: (e) ->
      e.preventDefault()
      txt = @getSelectionText()

      repl = "<u>#{txt}</u>"

      @replaceSelection repl

    textStrike: (e) ->
      e.preventDefault()
      txt = @getSelectionText()

      repl =
        if 'html' == @mode
          "<del>#{txt}</del>"
        else
          "~~#{txt}~~"

      @replaceSelection repl

    textQuote: (e) ->
      e.preventDefault()
      txt = @getSelectionText()

      repl =
        if 'html' == @mode
          """
          <blockquote>
          #{txt.replace(/^/mg, '\t')}
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
            #{txt}
            </code></pre>
            """
          else
            """
            <code>
            #{txt}
            </code>
            """
        else
          if txt.indexOf('\n') >= 0
            txt.replace /^/mg, '\t'
          else
            "`#{txt}`"

      @replaceSelection repl


  #  Sidebar View
  #-----------------------------------------------
  class SidebarView extends Backbone.View

    el: '#pocket_side'

    events:
      'scroll': 'hideDatepicker'
      'click #btn_delete': 'destroy'
      'click #post_thumbnail': 'thumbnailModal'

    initialize: ->
      @$form =
        date: $ '#post_date_str'
        tags: $ '#post_tag_list'

      @render()

    hideDatepicker: ->
      @$form.date.datepicker 'hide'

    render: ->
      @$form.date.datepicker format: 'yyyy.mm.dd'

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

    thumbnailModal: ->
      modal = Modal content: '/admin/media?modal=thumbnail', iframe: true
      modal.open()


  #  Initialize Backbone App
  #-----------------------------------------------
  new AppView()
  new EditorView()
  new SidebarView()
