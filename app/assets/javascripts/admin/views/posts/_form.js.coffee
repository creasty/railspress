require ['jquery', 'datepicker'], ($) ->
  $('#post_date_str').datepicker format: 'yyyy.mm.dd'


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


require ['jquery', 'common/notify', 'common/transit', 'domReady!'], ($, notify, transit) ->
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

      $form.prepend '<p>' + e + '</p>' for e in res.errors ? []

