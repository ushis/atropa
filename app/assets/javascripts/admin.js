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
})(jQuery);
