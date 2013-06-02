
define [
  'jquery'
  'components/statusbar'
  'components/notification'
], ($, Statusbar, Notification) ->
  parentSelector = '#globalheader'

  Statusbar.attachTo parentSelector

  class Notify
    constructor: ->
      @notifi = Notification.attachTo parentSelector
      console.log @notifi

    progress: (message, icon = 'clear') ->
      @notifi.trigger 'notifyProgress', [message, icon]

    success: (message, icon = 'check') ->
      @notifi.trigger 'notifySuccess', [message, icon]

    fail: (message, icon = 'ban') ->
      @notifi.trigger 'notifyFail', [message, icon]

  -> new Notify()
