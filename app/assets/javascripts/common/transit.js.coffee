define ['jquery'], ($) ->
  supportsHistoryAPI = window.history.pushState?
  $win = $ window

  changeUrl = (url) ->
    history.pushState '', '', url

  loadContent = ->
    $.ajax
      url: window.location.href
    .done (data) ->
      $('#main').html data

  handleClick = (e) ->
    link = e.currentTarget

    # click with decoration keys
    # should open links in a new tab as normal
    return if e.which > 1 \
      || e.metaKey || e.ctrlKey || e.shiftKey || e.altKey

    # ignore cross origin links
    return if location.protocol != link.protocol \
      || location.hostname != link.hostname

    # ignore anchors on the same page
    return if link.hash \
      && link.href.replace(link.hash, '') \
      == location.href.replace(location.hash, '')

    # Ignore empty anchor
    return if link.href == location.href + '#'

    changeUrl link.href

    e.preventDefault()

  events = ->
    $ ->
      # because WebKit-based browser
      # fires `popstate` as ready event fired.
      # so delay listening
      setTimeout ->
        $win.on 'popstate', -> loadContent()
      , 100

    $(document).on 'click', 'a', handleClick

  # Exports
  { changeUrl }
