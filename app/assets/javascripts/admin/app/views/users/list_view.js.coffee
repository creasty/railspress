
define [
  'jquery'
  'underscore'
  'backbone'
  'text!app/templates/users/list_item.html'
  'common/alert'
  'common/notify'

  'powertip'
], ($, _, Backbone, itemTemplate, Alert, Notify) ->

  class UserView extends Backbone.View

    tagName: 'tr'

    template: _.template itemTemplate

    events:
      'click': 'toggle'
      'click .icon-delete': 'delete'

    initialize: ->
      @model.view = @

      @listenTo @model, 'change', @onChange
      @listenTo @model, 'change:selected', @renderSelected

      @listenTo @model, 'destroy', @remove

    onChange: ->
      return if @model.hasChanged 'selected'
      @render()

    render: ->
      @$el.html @template @model.toJSON()
      @$checkbox = @$el.find '.checkbox'
      @$el.find('.btn').powerTip
        placement: 'n'
        smartPlacement: true
      @renderSelected()
      @

    renderSelected: ->
      if @model.get 'selected'
        @$checkbox.prop 'checked', true
        @$el.addClass 'selected'
      else
        @$checkbox.prop 'checked', false
        @$el.removeClass 'selected'

    toggle: -> @model.toggle()

    delete: (e) ->
      e.preventDefault()

      notify = Notify()

      Alert
        title: 'このユーザを削除しますか？'
        message: '関連するデータも全て削除します。<br />一度削除したユーザは復元することができません。'
        type: 'danger'
        btns: [
          { text: '削除', action: 'destroy', type: 'danger' }
          { text: 'キャンセル', action: 'close', align: 'right' }
        ]
        callback: (action, al) =>
          if action == 'destroy'
            notify.progress 'ユーザを削除しています...'
            al.close()

            @model.destroy
              wait: true
              success: (model, res) ->
                notify.success 'ユーザを削除しました'

