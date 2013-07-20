(function() {

  define(['jquery-ui'], function() {
    $.extend(true, Trst, {
      login: function(node) {
        var $login, $position, button;
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
          return $('input').first().focus();
        };
        $login = $('<div id="loginDialog"></div>');
        $position = $('#sidebar').position();
        $login.load(node.attr('href'), button).dialog({
          dialogClass: 'ui-dialog-shadow',
          autoOpen: false,
          modal: true,
          minHeight: 10,
          height: 'auto',
          width: 'auto',
          position: [$position.left, $position.top - 100],
          title: node.attr('title'),
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
