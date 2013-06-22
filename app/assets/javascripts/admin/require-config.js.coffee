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

    'jquery': [
      'http://cdnjs.cloudflare.com/ajax/libs/jquery/1.9.1/jquery.min'
      'jquery.min'
    ]

    'ace': 'ace/lib/ace'
    'backbone': 'backbone/backbone-min'
    'backbone.pageable': 'backbone-pageable/lib/backbone-pageable.min'
    'backbone.syphon': 'backbone.syphon/lib/backbone.syphon.min'
    'datepicker': 'datepicker/js/bootstrap-datepicker'
    'jcrop': 'jcrop/js/jquery.Jcrop.min'
    'markdown': 'markdown/lib/markdown'
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
    'hashchange': ['jquery']
    'jcrop': ['jquery', 'css!jcrop/../../css/jquery.Jcrop.min']
    'jquery_ujs': ['jquery']
    'masonry': ['jquery']
    'powertip': ['jquery']
    'selectize': ['jquery']
    'underscore': exports: '_'

