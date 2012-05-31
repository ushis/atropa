/**
 * admin.js
 *
 * @package   atropa
 * @requires  jQuery >= 1.7
 */
(function($) {

  $.fn.magicLogin = function(options) {
    var settings = $.extend({
      username: 'input[name=username]',
      password: 'input[name=password]'
    }, options);

    return this.each(function() {
      var username = $(this).find(settings.username);
      var password = $(this).find(settings.password);

      if (username.val().trim().length === 0) {
        if (localStorage.username) {
          username.val(localStorage.username);
          password.focus();
        } else {
          username.focus();
        }
      } else {
        password.focus();
      }

      $(this).submit(function() {
        localStorage.username = username.val().trim();
      });
    });
  };

  $.fn.magicRemoveButton = function() {
    return this.each(function() {
      (function(el) {
        el.append(
          $('<span>').addClass('rm').text('×').click(function() {
            el.fadeOut(400, function() {
              $(this).remove();
            });
          })
        );
      })($(this));
    });
  }

  $.fn.magicComplete = function(values) {
    return this.each(function() {
      $(this).autocomplete({
        minLength: 0,
        appendTo: $(this).parent(),
        source: function(req, res) {
          res($.ui.autocomplete.filter(values, req.term.split(/,\s*/).pop()));
        },
        focus: function() {
          return false;
        },
        select: function(e, ui) {
          var terms = this.value.split(/,\s*/);
          terms.pop();
          terms.push(ui.item.value);
          terms.push('');
          this.value = terms.join(', ');
          return false;
        }
      });
    });
  };
})(jQuery);
