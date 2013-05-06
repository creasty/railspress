@require =
  baseUrl: '/assets'

  paths:
    'jquery': [
      'http://cdnjs.cloudflare.com/ajax/libs/jquery/1.9.1/jquery.min'
      '/assets/components/jquery.min'
    ]
    'components': '/assets/components'
    'ace': '/assets/components/ace/lib/ace'
    'flight': '/assets/components/flight/lib'
    'hashchange': '/assets/components/jquery-hashchange/jquery.ba-hashchange.min'
    'tags-input': '/assets/components/tags-input/jquery.tagsinput.min'
    'jquery-autocomplete': '/assets/components/jquery-autocomplete/src/jquery.autocomplete.min'
    'datepicker': '/assets/components/datepicker/js/bootstrap-datepicker'
    'jcrop': '/assets/components/jcrop/js/jquery.Jcrop.min'

  map:
    '*':
      'ujs': 'jquery_ujs'
      'css': 'components/require-css/css'

  shim:
    'jquery_ujs': ['jquery']
    'jquery.remotipart': ['jquery']
    'hashchange': ['jquery']
    'tags-input': ['jquery', 'jquery-autocomplete']
    'jquery-autocomplete': ['jquery']
    'datepicker': ['jquery']
    'jcrop': ['jquery', 'css!jcrop/../../css/jquery.Jcrop.min']
