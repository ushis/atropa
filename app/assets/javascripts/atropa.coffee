# atropa.coffee
#
# requires  jQuery 1.7

do ($ = jQuery) ->
  $.fn.atropaSearch = (url, field) ->
    @each ->
      el = $(@).find "input[name=#{field}]"

      el.blur ->
        el.addClass('empty') if el.val().trim().length == 0

      el.focus ->
        el.removeClass('empty')

      $(@).submit ->
        val = el.val().trim()
        window.location.replace("#{url}/#{val}") if val.length > 0
        false

  $.fn.atropaVideo = ->
    @each ->
      do (el = $(@)) ->
        el.find('a.play').css(lineHeight: "#{el.height()}px").click ->
          src = $(@).attr('href') + '&autoplay=1'

          $(@).parent().html ->
            $('<iframe>').attr {
              src: src
              width: el.width()
              height: el.height()
              frameborder: 0
              allowfullscreen: true
            }

          false

  $.fn.atropaSimilar = () ->
    @each ->
      $(@).find('img').each ->
        if (height = (Number) $(@).attr('height')) > 0
          diff = ($(@).parent().height() - height) >> 1
          $(@).css(marginTop: "#{diff}px")
