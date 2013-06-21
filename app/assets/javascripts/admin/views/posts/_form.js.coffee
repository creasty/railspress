
require [
  'jquery'
  'underscore'
  'backbone'
  'app/models/post'
  'app/views/posts/edit_view'
  'common/notify'
  'common/alert'
  'ace/ace'

  'powertip'
  'datepicker'
  'tags-input'
  'ace/theme/solarized_light'
  'ace/mode/html'
  'domReady!'
], (
  $
  _
  Backbone
  Post
  EditView
  Notify
  Alert
  ACE
) ->


require ['jquery', 'datepicker', 'domReady!'], ($) ->
  $date = $ '#post_date_str'

  $date.datepicker format: 'yyyy.mm.dd'
  $('#pocket_side').on 'scroll', -> $date.datepicker 'hide'


require ['jquery', 'tags-input'], ($) ->
  $('#post_tags').tagsInput
    autocomplete_url: '/admin/terms/search.txt'
    autocomplete:
      selectFirst: true
      width: '100px'
      autoFill: true
    width: 260
    height: 'auto'
    defaultText: 'タグを追加'


require [
  'jquery'
  'ace/ace'
  'ace/theme/solarized_light'
  'ace/mode/html'
  'domReady!'
], ($, ace) ->
  $textarea = $('#post_content').hide()
  $('<div id="post_content_ace"></div>').insertBefore $textarea

  editor = ace.edit 'post_content_ace'
  editor.setTheme 'ace/theme/solarized_light'
  editor.getSession().setMode 'ace/mode/html'

  editor.getSession().setTabSize 2
  editor.getSession().setUseWrapMode true
  editor.setShowPrintMargin false
  editor.focus();

  editor.getSession().setValue $textarea.val()
  editor.getSession().on 'change', ->
    $textarea.val editor.getSession().getValue()

  editor.commands.addCommand
    name: 'Save'
    bindKey: win: 'Ctrl-S', mac: 'Command-S'
    readOnly: false
    exec: (editor) ->
      $('#post_form').submit()


require [
  'jquery'
  'common/notify'
  'common/transit'
  'common/alert'
  'domReady!'
], ($, notify, transit, Alert) ->
  st = notify()

  $form = $ 'form'

  $post_thumbnail = $ '#post_thumbnail'
  $post_thumbnail_preview = $ '#post_thumbnail_preview'

  $post_thumbnail_preview.find('i').on 'click', ->
    $post_thumbnail.click()

  $post_thumbnail.on 'change', (e) ->
    file = e.target.files[0]

    $post_thumbnail_preview.addClass('post-thumbnail').empty() if file

    $img = $('<img/>').appendTo $post_thumbnail_preview

    reader = new FileReader()

    reader.onload = (e) ->
      $img.attr 'src', e.target.result

    reader.readAsDataURL file

  $form
  .on 'submit', ->
    st.progress '変更を保存中'
  .on 'ajax:success', (_, res) ->
    if res.success
      st.success res.msg, 'save'
      $form.attr 'action', res.action

      if $form.find('input[name="_method"]').length == 0
        $form.append '<input type="hidden" name="_method" value="put">'
        transit.changeUrl res.redirect, false
    else
      st.fail res.msg

      Alert
        title: res.msg
        message: res.errors
        type: 'danger'
        btns: [
          { text: '修正する', action: 'close', type: 'danger' }
          { text: 'もう一度保存する', action: 'retry', type: 'success', align: 'right' }
        ]
        callback: (action, al) ->
          if action == 'retry'
            $form.submit()
            al.close()

