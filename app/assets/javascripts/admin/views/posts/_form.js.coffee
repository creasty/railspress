require [
  'jquery'
  'underscore'
  'backbone'
  'app/models/post'
  'common/notify'
  'common/alert'
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
  ACE
  Markdown
) ->

  ###
  post = new Post()
  new Post({ title: 'sdfa', status: 1, user_id: 1 }).save()
  post.fetch
    data: id: 75
    success: ->
      console.log post
      post.save title: post.get('title') + 2
  ###


  #  Componets
  #-----------------------------------------------
  UpdateNotify = Notify()


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
      Post.fetch data: { id }

    refresh: ->
      Backbone.Syphon.deserialize @, post: Post.attributes

    render: ->
      @

    save: (e) ->
      data = Backbone.Syphon.serialize @

      Post.save data.post,
        success: ->
          UpdateNotify.success 'success'
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
      'click #editor_mode_md': 'switchToMarkdown'
      'click #editor_mode_html': 'switchToHtml'

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

    insertLink: ->

    switchToHtml: (e) ->
      e.preventDefault()
      @setMode 'html'

    switchToMarkdown: (e) ->
      e.preventDefault()
      @setMode 'markdown'


  #  Sidebar View
  #-----------------------------------------------
  class SidebarView extends Backbone.View

    el: '#pocket_side'

    events:
      'scroll': 'hideDatepicker'
      'click #btn_delete': 'destroy'

    initialize: ->
      @$form =
        date: $ '#post_date_str'
        tags: $ '#post_tags'

      @render()

    hideDatepicker: ->
      @$form.date.datepicker 'hide'

    render: ->
      @$form.date.datepicker format: 'yyyy.mm.dd'

      @$form.tags.selectize
        plugins: ['remove_button']
        delimiter: ','
        persist: false
        valueField: 'value'
        labelField: 'text'
        searchField: ['text']
        options: [
          { value: 'apple', text: 'apple' }
          { value: 'banana', text: 'banana' }
          { value: 'car', text: 'car' }
          { value: 'desk', text: 'desk' }
          { value: 'egg', text: 'egg' }
          { value: 'flower', text: 'flower' }
          { value: 'glove', text: 'glove' }
          { value: 'hat', text: 'hat' }
          { value: 'ink', text: 'ink' }
          { value: 'jam', text: 'jam' }
        ]
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
                UpdateNotify.success '記事を削除しました'
              error: ->
                UpdateNotify.fail '記事の削除に失敗しました'


  #  Initialize Backbone App
  #-----------------------------------------------
  new AppView()
  new EditorView()
  new SidebarView()
