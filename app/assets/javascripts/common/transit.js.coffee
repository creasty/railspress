define ['jquery', 'hashchange'], ($) ->
  supportsHistoryAPI = window.history.pushState?
  $win = $ window

  changeUrl = (url, load = true) ->
    if supportsHistoryAPI
      history.pushState '', '', url
      loadContent() if load
    else
      location.hash = '!' + url

  loadContent = ->
    if supportsHistoryAPI
      $.ajax
        url: window.location.href
      .done (data) ->
        $('#main').html data

    else

      location.hash.replace '#', ''

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
      if supportsHistoryAPI
        # because WebKit-based browser
        # fires `popstate` as ready event fired.
        # so delay listening
        setTimeout ->
          $win.on 'popstate', -> loadContent()
        , 100
      else
        $win.on 'hashchange', -> loadContent()
        $win.trigger 'hashchange' # manually fire the event

    $(document).on 'click', 'a', handleClick

  # Exports
  { changeUrl }
