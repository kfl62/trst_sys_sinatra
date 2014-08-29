(function() {
  define(['jquery-ui'], function() {
    $.extend(true, Trst, {
      login: function(node) {
        var $login, init;
        init = function() {
          $('.cdate').val($.datepicker.formatDate('yy-mm-dd', new Date()));
          return $('input').first().focus();
        };
        $login = $('<div id="loginDialog"></div>');
        $login.load(node.attr('href'), init).dialog({
          autoOpen: false,
          modal: true,
          minHeight: 10,
          height: 'auto',
          width: 240,
          resizable: false,
          position: {
            my: 'right top',
            at: 'right top+20',
            of: 'body'
          },
          title: node.data('title'),
          close: function(ev, ui) {
            $(this).remove();
          }
        });
        $login.dialog('open');
      }
    });
    return Trst;
  });

}).call(this);
