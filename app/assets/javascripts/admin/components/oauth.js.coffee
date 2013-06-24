
define ['jquery', 'flight/lib/component'], ($, defineComponent) ->

  defineComponent ->

    @defaultAttrs
      name:     'oauth_popup'
      width:    600
      height:   400
      authUrl:  '/auth/:provider'

    @openPopup = (url) ->
      left = (window.screen.width - @attr.width) >> 1
      top = (window.screen.height - @attr.height) >> 1

      window.open url, @attr.name,
        "menubar=no,toolbar=no,status=no,width=#{@attr.width},height=#{@attr.height},toolbar=no,left=#{left},top=#{top}"

      false

    @closePopup = -> window[@attr.name]?.close()

    @getUrl = (provider) ->
      @attr.authUrl.replace /:provider\b/g, provider

    @link = (e, provider) ->
      @openPopup @getUrl provider

    @unlink = (e, provider) ->
      $.ajax
        url: @getUrl provider
        type: 'delete'
        success: =>
          $(window).trigger 'oauth:unlinked', provider

    @after 'initialize', ->
      @on 'oauth:link', @link
      @on 'oauth:unlink', @unlink
