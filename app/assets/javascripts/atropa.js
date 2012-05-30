/**
 * atropa.js
 *
 * @requires  jQuery 1.7
 */
(function($) {

  $.fn.magicSearch = function(url, field) {
    return this.each(function() {
      var el = $(this).find('input[name=' + field + ']');

      el.blur(function() {
        el.val().trim().length === 0 && el.addClass('empty');
      }).focus(function() {
        el.removeClass('empty');
      });

      $(this).submit(function() {
        var val = el.val().trim();

        if (val.length > 0) {
          window.location = url + '/' + val;
        }

        return false;
      });
    });
  };

  $.fn.atropaVideo = function() {
    return this.each(function() {
      (function(el) {
        el.find('a.play').css({lineHeight: el.height() + 'px'}).click(function() {
          var src = $(this).attr('href') + '&autoplay=1';

          $(this).parent().html(
            $('<iframe>').attr({
              src: src,
              width: el.width(),
              height: el.height(),
              frameborder: 0,
              allowfullscreen: true
            })
          );

          return false;
        });
      })($(this));
    });
  };
})(jQuery);
