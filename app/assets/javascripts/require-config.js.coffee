@require =
  baseUrl: '/assets'

  paths:
    'jquery': [
      'http://cdnjs.cloudflare.com/ajax/libs/jquery/1.9.1/jquery.min'
      'components/jquery.min'
    ]
    'components': './components'
    'ace': 'components/ace/lib/ace'
    'flight': 'components/flight/lib'
    'hashchange': 'components/jquery-hashchange/jquery.ba-hashchange.min'
    'tags-input': 'components/tags-input/jquery.tagsinput.min'
    'jquery-autocomplete': 'components/jquery-autocomplete/src/jquery.autocomplete.min'
    'datepicker': 'components/datepicker/js/bootstrap-datepicker'
    'jcrop': 'components/jcrop/js/jquery.Jcrop.min'

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
