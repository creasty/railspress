#= require jquery
#= require jquery_ujs
#= require_tree ./pages

require [
  'jquery'
  'flight/lib/index'
  'flight/tools/debug/debug'
], ($, flight, debug) ->

  debug.enable true

  flight.compose.mixin flight.registry, [
    flight.advice.withAdvice
    flight.logger
  ]

