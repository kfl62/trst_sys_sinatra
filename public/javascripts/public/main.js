(function() {
  define(['libs/trst_msg', 'public/trst_login', 'public/trst_map'], function() {
    $.extend(Trst, {
      init: function() {
        var $menuItems;
        Trst.msgHide();
        $('a.header-login').click(function() {
          Trst.login($(this));
          return false;
        });
        $menuItems = $('nav.menu ul li a').click(function() {
          $('#xhr_content').load("/" + ($(this).attr('id')));
          return false;
        });
        Trst.gmap($('#google_map')[0]);
        $(document).tooltip({
          content: function() {
            return $(this).attr('title').replace(/\n/g, "<br/>");
          }
        });
      }
    });
    return Trst;
  });

}).call(this);
