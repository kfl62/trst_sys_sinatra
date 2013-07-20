(function() {
  var __slice = [].slice;

  define(function() {
    var sysMsg;
    sysMsg = $.subscribe('xhrMsg', function(event, what, kind, data) {
      var $msg, $xhr_msg;
      $xhr_msg = $('#xhr_msg');
      $msg = eval("Trst.i18n." + what);
      if (typeof $msg === 'string') {
        $msg = $msg.replace('%{data}', data);
        $xhr_msg.html($msg).stop(true, true).addClass(kind).fadeIn(0).delay(2000).fadeOut(1000, 'linear', function() {
          $(this).removeAttr('class');
        });
      } else {
        $.ajax({
          url: "/utils/msg",
          type: 'POST',
          data: {
            what: what,
            kind: kind,
            data: data
          },
          dataType: 'json'
        }).done(function(data) {
          $xhr_msg.html(data.msg.txt).stop(true, true).addClass(data.msg["class"]).fadeIn(0).delay(2000).fadeOut(1000, 'linear', function() {
            $(this).removeAttr('class');
          });
        });
      }
    });
    $.extend(Trst, {
      publish: function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        $.publish('xhrMsg', args);
      },
      msgShow: function(msg) {
        if (msg == null) {
          msg = '...';
        }
        $('#xhr_msg').stop(true, true).fadeOut(0, 'linear', function() {
          $(this).removeAttr('class');
        }).html(msg).addClass('loading').fadeIn();
      },
      msgHide: function() {
        $('#xhr_msg').stop(true, true).fadeOut(500, 'linear', function() {
          $(this).removeAttr('class');
        });
      }
    });
    return Trst;
  });

}).call(this);
