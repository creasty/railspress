
define ['jquery'], ($) ->

  Timeago = (timestamp) ->
    if timestamp instanceof Date
      inWords timestamp
    else if typeof timestamp == 'string'
      inWords $.timeago.parse timestamp
    else if typeof timestamp == 'number'
      inWords new Date timestamp
    else
      inWords $.timeago.datetime timestamp

  $.extend Timeago,
    settings:
      refreshMillis: 5 * 600
      allowFuture: false
      localeTitle: false
      cutoff: 0
      strings:
        prefixAgo: null
        prefixFromNow: null
        suffixAgo: '前'
        suffixFromNow: '後'
        seconds: '%d秒'
        minute: '1分'
        minutes: '%d分'
        hour: '1時間'
        hours: '%d時間'
        day: '1日'
        days: '%d日'
        month: '1ヶ月'
        months: '%dヶ月'
        year: '1年'
        years: '%d年'
        wordSeparator: ''
        numbers: []

    inWords: (distanceMillis) ->
      $l = this.settings.strings
      prefix = $l.prefixAgo
      suffix = $l.suffixAgo

      if this.settings.allowFuture && distanceMillis < 0
        prefix = $l.prefixFromNow
        suffix = $l.suffixFromNow

      seconds = Math.abs(distanceMillis) / 1e3
      minutes = seconds / 60
      hours = minutes / 60
      days = hours / 24
      years = days / 365

      substitute = (stringOrFunction, number) ->
        string =
          if $.isFunction(stringOrFunction)
          then stringOrFunction(number, distanceMillis)
          else stringOrFunction

        value = ($l.numbers && $l.numbers[number]) || number
        string.replace /%d/i, value

      words =
        switch true
          when seconds < 45
            substitute $l.seconds, Math.round seconds
          when seconds < 90
            substitute $l.minute, 1
          when minutes < 45
            substitute $l.minutes, Math.round minutes
          when minutes < 90
            substitute $l.hour, 1
          when hours < 24
            substitute $l.hours, Math.round hours
          when hours < 42
            substitute $l.day, 1
          when days < 30
            substitute $l.days, Math.round days
          when days < 45
            substitute $l.month, 1
          when days < 365
            substitute $l.months, Math.round days / 30
          when years < 1.5
            substitute $l.year, 1
          else
            substitute $l.years, Math.round years

      separator = $l.wordSeparator ? ' '
      $.trim [prefix, words, suffix].join separator

    parse: (iso8601) ->
      s = $.trim(iso8601)
        .replace(/\.\d+/, '')
        .replace(/-/g, '/')
        .replace(/T/, ' ')
        .replace(/Z/, ' UTC')
        .replace(/([\+\-]\d\d)\:?(\d\d)/, ' $1$2')

      new Date s

    datetime: (elem) ->
      if elem.data 'timestamp'
        new Date elem.data 'timestamp'
      else
        iso8601 =
          if Timeago.isTime(elem)
          then $(elem).attr 'datetime'
          else $(elem).attr 'title'

        Timeago.parse iso8601

    isTime: (elem) ->
      tag = $(elem)
      .get(0)
      .tagName
      .toLowerCase()

      tag == 'time'

  functions =
    init: ->
      do refresh_el = refresh.bind @
      rf = Timeago.settings.refreshMillis
      setInterval refresh_el, rf if rf > 0

    update: (time) ->
      $(@).data 'timeago', datetime: Timeago.parse time
      refresh.apply @

    updateFromDOM: ->
      $t = $ @
      time =
        if Timeago.isTime @
        then $t.attr 'datetime'
        else $t.attr 'title'

      $t.data 'timeago', datetime: Timeago.parse time
      refresh.apply @

  refresh = ->
    data = prepareData @
    cutoff = Timeago.settings.cutoff

    if (
      !isNaN data.datetime \
      && cutoff == 0 \
      || distance(data.datetime) < cutoff
    )
      $(@).text inWords data.datetime

    @

  prepareData = (element) ->
    element = $ element

    unless element.data 'timeago'
      element.data 'timeago', datetime: Timeago.datetime element
      text = $.trim element.text()

      if Timeago.settings.localeTitle
        element.attr 'title', element.data('timeago').datetime.toLocaleString()
      else if (
        text.length > 0 \
        && !(
          Timeago.isTime(element) \
          && element.attr('title')
        )
      )
        element.attr 'title', text

    element.data 'timeago'

  inWords = (date) ->
    Timeago.inWords distance date

  distance = (date) ->
    new Date().getTime() - date.getTime()

  $.fn.timeago = (action, options) ->
    fn = functions[action ? 'init']
    return unless fn
    @each -> fn.call @, options

  $.timeago = Timeago
