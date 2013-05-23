
define [
  'jquery'
  'components/statusbar'
  'components/notify'
], ($, Statusbar, Notify) ->
  Notify.attachTo '#globalheader',
    statusbarSelector

  Statusbar.attachTo '#globalheader'

