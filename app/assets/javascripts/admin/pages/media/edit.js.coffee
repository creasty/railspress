require ['jquery', 'jcrop', 'panzoom', 'domReady!'], ($) ->
  $x = $ '#crop_x'
  $y = $ '#crop_y'
  $w = $ '#crop_w'
  $h = $ '#crop_h'

  update_crop = (coords) ->
    $x.val coords.x
    $y.val coords.y
    $w.val coords.w
    $h.val coords.h

  getSelection = ->
    x = parseInt $x.val(), 10
    y = parseInt $y.val(), 10
    w = parseInt $w.val(), 10
    h = parseInt $h.val(), 10

    return if isNaN x + y + w + h

    [x, y, x + w, y + h]

  $('#cropbox').Jcrop
    onChange: update_crop
    onSelect: update_crop
    setSelect: getSelection()
    # aspectRatio: 1

  ###
  $zoom_controller = $ '#zoom_contorller'
  $('#zoom').panzoom
    $zoomIn: $ '.zoom-in'
    $zoomOut: $ '.zoom-out'
    $zoomRange: $ '.zoom-range'
    $reset: $ '.reset'
  ###
