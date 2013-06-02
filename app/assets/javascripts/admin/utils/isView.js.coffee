define ['jquery', 'domReady!'], ($) ->
  $body = $ 'body'
  controller = $body.attr 'id'
  action = $body.attr('class').split(' ')[0]

  _isView = (to) ->
    [ct, ac] = to.split '#'
    ct == controller && (!ac? || ac == action)

  isView = (to...) ->
    for t in to
      return true if _isView t

    false

  isView.load = (name, req, onLoad, config) ->
    onLoad() if _isView name

  isView
