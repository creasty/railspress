@require =
  baseUrl: '/assets'

  paths:
    'common': 'admin/common'
    'components': 'admin/components'
    'views': 'admin/views'
    'ui': 'admin/ui'
    'mixin': 'admin/mixin'
    'utils': 'admin/utils'

    'jquery': [
      'http://cdnjs.cloudflare.com/ajax/libs/jquery/1.9.1/jquery.min'
      'jquery.min'
    ]
    'ace': 'ace/lib/ace'
    'tags-input': 'tags-input/jquery.tagsinput.min'
    'jquery-autocomplete': 'jquery-autocomplete/src/jquery.autocomplete.min'
    'datepicker': 'datepicker/js/bootstrap-datepicker'
    'jcrop': 'jcrop/js/jquery.Jcrop.min'
    'panzoom': 'panzoom/dist/jquery.panzoom.min'
    'filedrop': 'filedrop/jquery.filedrop'
    'masonry': 'jquery-masonry/jquery.masonry.min'

  map:
    '*':
      'ujs': 'jquery_ujs'
      'css': 'require-css/css'

  shim:
    'jquery_ujs': ['jquery']
    'hashchange': ['jquery']
    'tags-input': ['jquery', 'jquery-autocomplete']
    'jquery-autocomplete': ['jquery']
    'datepicker': ['jquery']
    'jcrop': ['jquery', 'css!jcrop/../../css/jquery.Jcrop.min']
    'panzoom': ['jquery']
    'filedrop': ['jquery']
    'masonry': ['jquery']

