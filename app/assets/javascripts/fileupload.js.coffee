
require.config
  map:
    '*':
      'jquery.ui.widget': 'jquery-fileupload/vendor/jquery.ui.widget'
      'load-image': 'jquery-fileupload/vendor/load-image'
      'canvas-to-blob': 'jquery-fileupload/vendor/canvas-to-blob'
      'tmpl': 'jquery-fileupload/vendor/tmpl'

define [
  'jquery'
  'jquery.ui.widget'
  'load-image'
  'canvas-to-blob'
  'tmpl'
  'jquery-fileupload/jquery.iframe-transport'
  'jquery-fileupload/jquery.fileupload'
  'jquery-fileupload/jquery.fileupload-fp'
  'jquery-fileupload/jquery.fileupload-ui'
  'jquery-fileupload/locale'
], ($) ->
  -> $
