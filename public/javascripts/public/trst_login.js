(function() {
  define(['jquery-ui'], function() {
    $.extend(true, Trst, {
      login: function(node) {
        var $login, button;
        button = function() {
          $('#loginDialog').find('button').each(function() {
            var $button;
            $button = $(this);
            $button.button({
              icons: {
                primary: $button.data('icon')
              }
            });
          });
          $('.cdate').val($.datepicker.formatDate('yy-mm-dd', new Date()));
          return $('input').first().focus();
        };
        $login = $('<div id="loginDialog"></div>');
        $login.load(node.attr('href'), button).dialog({
          dialogClass: 'ui-dialog-shadow',
          autoOpen: false,
          modal: true,
          minHeight: 10,
          height: 'auto',
          width: 'auto',
          position: {
            my: 'left top',
            at: 'left-50 top+20',
            of: '#login_status'
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
