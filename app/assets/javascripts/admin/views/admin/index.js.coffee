
require [
  'jquery'
  'underscore'
  'components/line_chart'
  'domReady!'
], ($, _, LineChart) ->

  $google_analytics = $ '#google_analytics'
  $google_analytics_table = $ '#google_analytics_table'
  $twitter_share = $ '#twitter_share'
  $facebook_reports = $ '#facebook_reports'
  $activities = $ '#activities'

  $.ajax
    url: '/admin/activities'
    success: (data) ->
      $activities.removeClass 'loader'

      LineChart.attachTo $activities,
        values: data.values
        labels: data.labels
        tooltips: data.tooltips
        padding: [60, 20, 50, 20]


  $.ajax
    url: '/admin/google_analytics'
    success: (data) ->
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

      for se in data.search
        $google_analytics_table.append temp se

      $google_analytics.removeClass 'loader'

      LineChart.attachTo $google_analytics,
        unit: ' PV'
        values: data.pageviews.values
        labels: data.pageviews.labels
        padding: [60, 20, 50, 20]


  $facebook_reports.removeClass 'loader'
  LineChart.attachTo $facebook_reports,
    unit: ' 人'
    values: Array(Array(15)...).map (v, i) -> (Math.random() * 400) | 0
    labels: Array(Array(15)...).map (v, i) -> (11 + i) % 31
    padding: [60, 20, 50, 20]
