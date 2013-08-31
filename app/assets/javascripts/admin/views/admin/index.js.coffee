
require [
  'jquery'
  'underscore'
  'components/chart'
  'domReady!'
], ($, _, Chart) ->

  $activities = $ '#activities'
  $commits = $ '#commits'
  $ga = $ '#google_analytics'
  $ga_table = $ '#google_analytics_table'

  $.ajax
    url: '/admin/activities'
    success: ({ commits, ga }) ->
      $activities.removeClass 'loader'

      Chart.attachTo $commits,
        type:     'bar'
        values:   commits.values
        labels:   commits.labels
        tooltips: commits.tooltips

      temp = _.template """
        <tr>
          <td><a href="<%= page_path %>" target="_blank"><%= page_title %></a></td>
          <td><%= pageviews %></td>
          <td><%= organic %></td>
          <td><%= new_visits %></td>
          <td><%= exit_rate %></td>
          <td><%= source %></td>
        </tr>
      """

      $ga_table.append temp se for se in ga.search

      Chart.attachTo $ga,
        unit:  ' PV'
        values: ga.pageviews.values
        labels: ga.pageviews.labels
