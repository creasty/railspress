@require =
  baseUrl: '/assets'

  paths:
    # Admin
    'app': 'admin/app'
    'common': 'admin/common'
    'components': 'admin/components'
    'mixin': 'admin/mixin'
    'ui': 'admin/ui'
    'utils': 'admin/utils'
    'views': 'admin/views'

    'ace': 'ace/lib/ace'
    'backbone': 'backbone/backbone-min'
    'backbone.pageable': 'backbone-pageable/lib/backbone-pageable.min'
    'backbone.syphon': 'backbone.syphon/lib/backbone.syphon.min'
    'datepicker': 'datepicker/js/bootstrap-datepicker'
    'easing': 'jquery.easing.min'
    'jquery': 'jquery.min'
    'jcrop': 'jcrop/js/jquery.Jcrop.min'
    'masonry': 'jquery-masonry/jquery.masonry.min'
    'powertip': 'powertip/jquery.powertip.min'
    'selectize': 'selectize/selectize.min'
    'underscore': 'underscore/underscore-min'

  map:
    '*':
      'css': 'require-css/css'
      'domReady': 'requirejs-domready/domReady'
      'text': 'requirejs-text/text'

  shim:
    'backbone':
      deps: ['jquery', 'underscore']
      exports: 'Backbone'
    'backbone.pageable': ['backbone']
    'backbone.syphon': ['backbone']
    'datepicker': ['jquery']
    'easing': ['jquery']
    'jcrop': ['jquery', 'css!jcrop/../../css/jquery.Jcrop.min']
    'jquery_ujs': ['jquery']
    'masonry': ['jquery']
    'powertip': ['jquery']
    'selectize': ['jquery']
    'underscore': exports: '_'

