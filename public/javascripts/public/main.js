(function() {

  define(['libs/trst_msg', 'public/trst_login', 'public/trst_map'], function() {
    $.extend(Trst, {
      init: function() {
        var $menuItems;
        Trst.msgHide();
        $('#login_status[href$="login"]').click(function() {
          Trst.login($(this));
          return false;
        });
        $menuItems = $('#menu.public ul li a').click(function() {
          $('#xhr_content').load("/" + ($(this).attr('id')));
          return false;
        });
        Trst.gmap($('#google_map')[0]);
      }
    });
    return Trst;
  });

}).call(this);
