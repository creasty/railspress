@require =
  baseUrl: '/assets'

  paths:
    # Admin
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
    'datepicker': 'datepicker/js/bootstrap-datepicker'
    'filedrop': 'jquery-filedrop/jquery.filedrop'
    'jcrop': 'jcrop/js/jquery.Jcrop.min'
    'jquery-autocomplete': 'jquery-autocomplete/src/jquery.autocomplete.min'
    'masonry': 'jquery-masonry/jquery.masonry.min'
    'panzoom': 'jquery.panzoom/dist/jquery.panzoom.min'
    'tags-input': 'tags-input/jquery.tagsinput.min'
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
    'datepicker': ['jquery']
    'filedrop': ['jquery']
    'hashchange': ['jquery']
    'jcrop': ['jquery', 'css!jcrop/../../css/jquery.Jcrop.min']
    'jquery-autocomplete': ['jquery']
    'jquery_ujs': ['jquery']
    'masonry': ['jquery']
    'panzoom': ['jquery']
    'tags-input': ['jquery', 'jquery-autocomplete']
    'underscore': exports: '_'

