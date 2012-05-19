/**
 * atropa.js
 *
 * @requires  jQuery 1.7
 */
(function($) {

  $.fn.magicSearch = function(url, field) {
    return this.each(function() {
      $(this).submit(function() {
        var val = $(this).find('input[name=' + field + ']').val().trim();

        if (val.length > 0) {
          window.location = url + '/' + val;
        }

        return false;
      });
    });
  };

  $.fn.atropaVideo = function() {
    return this.each(function() {
      var el = $(this);

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
    });
  };
})(jQuery);
