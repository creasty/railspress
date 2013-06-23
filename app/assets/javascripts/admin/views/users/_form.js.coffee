require [
  'jquery'
  'underscore'
  'backbone'
  'app/models/user'
  'common/notify'
  'common/alert'

  'backbone.syphon'
  'domReady!'
], (
  $
  _
  Backbone
  User
  Notify
  Alert
) ->

  #  Componets
  #-----------------------------------------------
  UpdateNotify = Notify()

  #  Model
  #-----------------------------------------------
  User = new User()

  #  App View
  #-----------------------------------------------
  class AppView extends Backbone.View

    el: '#user_form'

    events:
      'submit': 'prevent'
      'save':   'save'

    initialize: ->
      @load()
      @render()
      @

    load: ->
      id = $('#user_form').data 'id'

      if id?
        id >>>= 0
        model = Backbone.Syphon.serialize(@).user
        model.id = id
        User.id = id
        User.set model

    refresh: ->
      Backbone.Syphon.deserialize @, user: User.attributes

    render: -> @

    save: (e) ->
      data = Backbone.Syphon.serialize @

      isSynced = User.isSynced()

      User.save data.user,
        success: ->
          if isSynced
            UpdateNotify.success '保存しました'
          else
            window.location.href = User.get 'edit_link'
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

  #  Sidebar View
  #-----------------------------------------------
  class SidebarView extends Backbone.View

    el: '#pocket_side'

    events:
      'click #btn_delete': 'destroy'
      'click #btn_save': 'save'

    initialize: ->
      @$form = $ '#user_form'

    save: (e) ->
      @$form.trigger 'save'

    destroy: ->
      Alert
        title: "ユーザを削除しますか？"
        message: '一度削除するともとに戻すことはできません。'
        type: 'danger'
        btns: [
          { text: '削除', action: 'destroy', type: 'danger' }
          { text: 'キャンセル', action: 'close', align: 'right' }
        ]
        callback: (action, al) =>
          if action == 'destroy'
            UpdateNotify.progress 'ユーザを削除しています...'
            al.close()

            User.destroy
              success: ->
                window.location.href = User.urlRoot
              error: ->
                UpdateNotify.fail 'ユーザの削除に失敗しました'


  #  Initialize Backbone App
  #-----------------------------------------------
  new AppView()
  new SidebarView()
