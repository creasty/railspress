@require =
  baseUrl: '/assets'

  paths:
    'jquery': [
      'http://cdnjs.cloudflare.com/ajax/libs/jquery/1.9.1/jquery.min'
      'jquery.min'
    ]
    'ace': 'ace/lib/ace'
    'flight': 'flight/lib'
    'hashchange': 'jquery-hashchange/jquery.ba-hashchange.min'
    'tags-input': 'tags-input/jquery.tagsinput.min'
    'jquery-autocomplete': 'jquery-autocomplete/src/jquery.autocomplete.min'
    'datepicker': 'datepicker/js/bootstrap-datepicker'
    'jcrop': 'jcrop/js/jquery.Jcrop.min'
    'flight': 'flight/lib'

  map:
    '*':
      'ujs': 'jquery_ujs'
      'css': 'require-css/css'

  shim:
    'jquery_ujs': ['jquery']
    'jquery.remotipart': ['jquery']
    'hashchange': ['jquery']
    'tags-input': ['jquery', 'jquery-autocomplete']
    'jquery-autocomplete': ['jquery']
    'datepicker': ['jquery']
    'jcrop': ['jquery', 'css!jcrop/../../css/jquery.Jcrop.min']
