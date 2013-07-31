
require [
  'jquery'
  'underscore'
  'components/line_chart'
  'domReady!'
], ($, _, LineChart) ->

  $activities = $ '#activities'
  $commits = $ '#commits'
  $google_analytics = $ '#google_analytics'
  $google_analytics_table = $ '#google_analytics_table'

  $.ajax
    url: '/admin/activities'
    success: ({commits, ga}) ->
      $activities.removeClass 'loader'

      LineChart.attachTo $commits,
        values: commits.values
        labels: commits.labels
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

      for se in ga.search
        $google_analytics_table.append temp se

      LineChart.attachTo $google_analytics,
        unit: ' PV'
        values: ga.pageviews.values
        labels: ga.pageviews.labels
