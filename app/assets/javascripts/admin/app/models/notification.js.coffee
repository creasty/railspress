
define [
  'underscore'
  'backbone'
], (_, Backbone) ->

  class Notification extends Backbone.Model

    urlRoot: '/admin/notifications'
