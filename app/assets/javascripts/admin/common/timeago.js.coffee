define ['jquery'], ($) ->
  class TimeAgo

    constructor: (@$element, @timestamp, @i18n) ->
      @startInterval = 6e4
      @updateTime()
      @startTimer()

    startTimer: ->
      @interval = setInterval (=> @refresh()), @startInterval

    stopTimer: -> clearInterval @interval

    restartTimer: ->
      @stopTimer()
      @startTimer()

    refresh: ->
      @updateTime()
      @updateInterval()

    updateTime: ->
      @$element.each (_, el) => $(el).text @toWords()

    updateInterval: ->
      t = @getTimeDistance()

      if 0 <= t <= 44 && @startInterval != 6e4 #1 minute
        @startInterval = 6e4
        @restartTimer()
      else if 45 <= t <= 89 && @startInterval != 6e4 * 22 #22 minutes
        @startInterval = 6e4 * 22
        @restartTimer()
      else if 90 <= t <= 2519 && @startInterval != 6e4 * 30 #half hour
        @startInterval = 6e4 * 30
        @restartTimer()
      else if 2520 <= t && @startInterval != 6e4 * 60 * 12 #half day
        @startInterval = 6e4 * 60 * 12
        @restartTimer()

    toWords: (t) ->
      "#{@i18n.prefixes.ago}#{@distanceOfTimeInWords(t)}#{@i18n.suffix}"

    getTimeDistance: ->
      timeDistance = new Date().getTime() - @timestamp.getTime()
      Math.round Math.abs(timeDistance) / 6e4

    distanceOfTimeInWords: ->
      dim = @getTimeDistance()

      if dim == 0
        "#{ @i18n.units.minute }#{ @i18n.prefixes.lt }"
      else if dim == 1
        "#{ @i18n.units.minute }"
      else if dim >= 2 and dim <= 44
        "#{ dim }#{ @i18n.units.minutes }"
      else if dim >= 45 and dim <= 89
        "#{ @i18n.prefixes.about }1#{ @i18n.units.hour }"
      else if dim >= 90 and dim <= 1439
        "#{ @i18n.prefixes.about }#{ Math.round(dim / 60) }#{ @i18n.units.hours }"
      else if dim >= 1440 and dim <= 2519
        "1 #{ @i18n.units.day }"
      else if dim >= 2520 and dim <= 43199
        "#{ Math.round(dim / 1440) }#{ @i18n.units.days }"
      else if dim >= 43200 and dim <= 86399
        "#{ @i18n.prefixes.about }1#{ @i18n.units.month }"
      else if dim >= 86400 and dim <= 525599 #1 yr
        "#{ Math.round(dim / 43200) }#{ @i18n.units.months }"
      else if dim >= 525600 and dim <= 655199 #1 yr, 3 months
        "#{ @i18n.prefixes.about }1#{ @i18n.units.year }"
      else if dim >= 655200 and dim <= 914399 #1 yr, 9 months
        "#{ @i18n.prefixes.over }1#{ @i18n.units.year }"
      else if dim >= 914400 and dim <= 1051199 #2 yr minus half minute
        "#{ @i18n.prefixes.almost }2#{ @i18n.units.years }"
      else
        "#{ @i18n.prefixes.about }#{ Math.round(dim / 525600) }#{ @i18n.units.years }"

  $.fn.timeago = (timestamp, i18n = {}) ->
    i18n = $.extend {}, $.timeago.i18n, i18n

    @each -> new TimeAgo $(@), timestamp, i18n

  $.timeago = ($el, timestamp, i18n) ->
    $el = $ $el unless $el instanceof $
    $el.timeago timestamp, i18n

  $.timeago.i18n =
    units:
      second: "1秒"
      seconds: "秒"
      minute: "1分"
      minutes: "分"
      hour: "1時間"
      hours: "時間"
      day: "1日"
      days: "日"
      month: "1ヶ月"
      months: "ヶ月"
      year: "1年"
      years: "年"
    prefixes:
      lt: "より"
      about: "訳"
      over: "over"
      almost: "almost"
      ago: ""
    suffix: '前'


  # Exports
  $.timeago
