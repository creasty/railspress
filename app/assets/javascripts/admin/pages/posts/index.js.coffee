
require ['utils/isView'], (isView) ->
  return unless isView 'posts#index'

  require [
    'jquery'
    'common/transit'
    'domReady!'
  ], ($, transit) ->
    $tbody = $ '#main > table > tbody'

    $(document).on 'click', 'ul.pagination a', (e) ->
      $t = $ @
      link = $t.get(0).href
      $.ajax
        url: link
        data: only_table: true
      .done (json) ->
        $('ul.pagination').replaceWith json.pager
        $tbody.html json.html
        transit.changeUrl link, false

      e.preventDefault()


  require [
    'jquery'
    'common/notify'
    'components/viewstate'
    'domReady!'
  ], ($, Notify, Viewstate) ->
    st = Notify()
    bulk_count = 0
    $view = $ 'div[data-toggle="bulk-action"]'
    Viewstate.attachTo $view

    $selecting = $view.filter '[data-state=selecting]'
    $counter = $selecting.find 'span.counter'

    $(document)
    .on 'change', 'tr.post td.bulk input', ->
      $t = $ @
      $t_tr = $t.closest('tr')
      checked = $t.is(':checked')

      if checked
        $t_tr.addClass 'hover'
        ++bulk_count
      else
        $t_tr.removeClass 'hover'
        --bulk_count

      if bulk_count > 1
        $view.trigger 'changeViewstate', 'selecting'
        $counter.text bulk_count
      else
        $view.trigger 'changeViewstate', 'normal'

    $(document)
    .on 'click', 'tr.post a[data-method="delete"]', ->
      st.progress '記事を削除しています'
    .on 'ajax:success','tr.post a[data-method="delete"]', (e, res) ->
      if res.success
        $post = $ '#post_' + res.id

        $post
        .animate
          opacity: 0
        ,
          complete: ->
            st.success res.msg
            $post.remove()

            $.ajax
              url: window.location.href
              data: only_table: true
            .done (json) ->
              $('ul.pagination').replaceWith json.pager
              $('table > tbody').html json.html


