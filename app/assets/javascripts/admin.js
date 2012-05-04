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
      username = $(this).find(settings.username);

      if (username.length > 0 && username.val().trim().length === 0) {
        username.focus();
      } else {
        $(this).find(settings.password).focus();
      }
    });
  };

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
