###
admin.coffe

@requires  jQuery >= 1.7
###
do ($ = jQuery) ->
  $.fn.magicLogin = (options) ->
    settings = $.extend {
      username: 'input[name=username]',
      password: 'input[name=password]'
    }, options

    @each ->
      username = $(@).find settings.username
      password = $(@).find settings.password

      $(@).submit ->
        localStorage.username = username.val().trim()

      if username.val().trim().length > 0
        password.focus()
        return

      if localStorage.username
        username.val localStorage.username
        password.focus()
      else
        username.focus()

  $.fn.magicRemoveButton = () ->
    @each ->
      do (el = $(@)) ->
        el.append(
          $('<span>').addClass('rm').text('×').click ->
            el.fadeOut 400, ->
              $(@).remove()
        )

  $.fn.magicComplete = (values) ->
    @each ->
      $(@).autocomplete {
        minLength: 0,
        appendTo: $(@).parent(),
        source: (req, res) ->
          res($.ui.autocomplete.filter(values, req.term.split(/,\s*/).pop()))
        focus: () ->
          false
        select: (e, ui) ->
          terms = @value.split(/,\s*/)
          terms.pop()
          terms.push(ui.item.value)
          terms.push('')
          @.value = terms.join(', ')
          false
      }
