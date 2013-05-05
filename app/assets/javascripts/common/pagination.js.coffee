define ['jquery'], ($) ->
  pageLink = (num) ->
    encodeURIComponent num

  entriyHtml = (num, cls, name = null, title = null) ->
    if $.isNumeric(cls) && cls == num
      cls = ' active'
    else if 'string' == typeof cls
      cls = ' ' + cls
    else
      cls = ''

    name ?= num
    title ?= num + 'ページへ'
    link = pageLink num

    "<li><a href=\"#{link}\" title=\"#{title}\" class=\"btn#{cls}\">$name</a></li>"

  make = (current, pagemax, entries = 2, edge = 2) ->
    html = []

    ne_half = Math.ceil entries / 2
    upper_limit = pagemax - entries + 1
    start =
      if current > ne_half
        Math.max(Math.min(current - ne_half, upper_limit), 1)
      else
        1

    end =
      if current > ne_half
        Math.min current + ne_half - 1, pagemax
      else
        Math.min entries, pagemax

    start = if start > edge + 1 then start else 1
    end = if end < pagemax - edge then end else pagemax

    # Prev
    if current > 1
      html.push entriyHtml(current - 1, 'page-new', '&laquo;', '新しい記事へ')

    # Starting Point
    if start > edge + 1
      for i in [1...edge] by 1
        html.push entriyHtml($i, $current)

      html.push '<li class="ellipsis">...</li>'

    # Entries
    for i in [start..end] by 1
      html.push entriyHtml($i, $current)

    # Ending Point
    if $end < $pagemax
      html.push '<li class="ellipsis">...</li>'
      for i in [(pagemax - edge + 1)..pagemax] by 1
        html.push entriyHtml($i, $current)

    # Next
    if $current < $pagemax
      html.push entriyHtml($current + 1, 'page-old', '&raquo;', '古い記事へ')

    html.join ''
