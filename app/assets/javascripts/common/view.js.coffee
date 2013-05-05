define ['jquery', 'domReady!'], ($) ->
  $body = $ 'body'
  controller = $body.attr 'id'
  action = $body.attr('class').split(' ')[0]

  view = (to) ->
    [ct, ac] = to.split '#'
    ct == controller && (!ac? || ac == action)

  view.load = (name, req, onLoad, config) ->
    onLoad() if view name

  view
