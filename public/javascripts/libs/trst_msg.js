(function() {
  var __slice = [].slice;

  define(function() {
    var sysMsg;
    sysMsg = $.subscribe('xhrMsg', function(event, what, kind, data) {
      var $icon, $msg, $xhr_msg, d;
      $xhr_msg = $('#xhr_msg');
      $msg = eval("Trst.i18n." + what);
      if (typeof $msg === 'string') {
        $msg = $msg.replace('%{data}', data);
        $icon = (function() {
          switch (false) {
            case kind !== 'info':
              return 'fa fa-info-circle fa-lg blue';
            case kind !== 'warning':
              return 'fa fa-exclamation-triangle fa-lg';
            case kind !== 'error':
              return 'fa fa-bomb fa-lg';
            default:
              return 'fa fa-refresh fa-spin fa-lg';
          }
        })();
        if (kind === 'error') {
          d = 5000;
        } else {
          d = 2000;
        }
        $xhr_msg.html("<span>" + $msg + "</span>").stop(true, true).addClass(kind).prepend("<i class='" + $icon + "'></i>").fadeIn(0).delay(d).fadeOut(1000, 'linear', function() {
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
          if (data.msg.cls === 'error') {
            d = 5000;
          } else {
            d = 2000;
          }
          $icon = (function() {
            switch (false) {
              case data.msg.cls !== 'info':
                return 'fa fa-info-circle fa-lg blue';
              case data.msg.cls !== 'warning':
                return 'fa fa-exclamation-triangle fa-lg';
              case data.msg.cls !== 'error':
                return 'fa fa-bomb fa-lg';
              default:
                return 'fa fa-refresh fa-spin fa-lg';
            }
          })();
          $xhr_msg.html("<span>" + data.msg.txt + "</span>").stop(true, true).addClass(data.msg.cls).prepend("<i class='" + $icon + "'></i>").fadeIn(0).delay(d).fadeOut(1000, 'linear', function() {
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
      msgShow: function(msg, cls) {
        var $icon;
        if (msg == null) {
          msg = '<span>...</span>';
        }
        if (cls == null) {
          cls = 'loading';
        }
        $icon = (function() {
          switch (false) {
            case cls !== 'info':
              return 'fa fa-info-circle fa-lg blue';
            case cls !== 'warning':
              return 'fa fa-exclamation-triangle fa-lg';
            case cls !== 'error':
              return 'fa fa-bomb fa-lg';
            default:
              return 'fa fa-refresh fa-spin fa-lg';
          }
        })();
        $('#xhr_msg').stop(true, true).fadeOut(0, 'linear', function() {
          $(this).removeAttr('class');
        }).html(msg).prepend("<i class='" + $icon + "'></i>").addClass(cls).fadeIn();
      },
      msgHide: function() {
        var d;
        if ($('#xhr_msg').hasClass('error')) {
          d = 5000;
        } else {
          d = 0;
        }
        $('#xhr_msg').stop(true, true).delay(d).fadeOut(500, 'linear', function() {
          $(this).removeAttr('class');
        });
      }
    });
    return Trst;
  });

}).call(this);
