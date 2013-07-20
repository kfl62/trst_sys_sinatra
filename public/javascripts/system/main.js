(function() {

  define(['/javascripts/libs/jquery.fileDownload.js', 'libs/trst_msg', 'system/trst_desk'], function() {
    Storage.prototype.setObject = function(key, value) {
      return this.setItem(key, JSON.stringify(value));
    };
    Storage.prototype.getObject = function(key) {
      var value;
      value = this.getItem(key);
      return value && JSON.parse(value);
    };
    Number.prototype.round = function(n) {
      if (n == null) {
        n = 0;
      }
      return Math.round(this * Math.pow(10, n)) / Math.pow(10, n);
    };
    $.extend($.fn, {
      decValue: function(n) {
        if (n == null) {
          n = 0;
        }
        return this.each(function() {
          var e;
          e = $(this);
          return e.change(function() {
            return this.value = parseFloat(this.value).round(n);
          });
        });
      }
    });
    $.extend($.fn, {
      decFixed: function(n) {
        if (n == null) {
          n = 0;
        }
        return this.each(function() {
          var e;
          e = $(this);
          return e.val(parseFloat(e.val()).toFixed(n));
        });
      }
    });
    $.extend(true, Trst, {
      lst: sessionStorage,
      i18n: sessionStorage.getObject('i18n'),
      init: function() {
        var $helpClose, $helpers, $menuItems, $tasks;
        Trst.msgHide();
        if (Trst.lst.i18n == null) {
          $.post('/utils/msg', function(data) {
            Trst.lst.setObject('i18n', data.msg.txt);
            Trst.i18n = Trst.lst.getObject('i18n');
            delete Trst.i18n.sidebar;
            delete Trst.i18n.login;
          }, 'json');
        }
        $menuItems = $('#menu.system ul li a').click(function() {
          $('#xhr_content').load("/sys/" + ($(this).attr('id')));
          return false;
        }).filter('[id^="page"]').click(function() {
          $('#xhr_content').load("/sys/" + ($(this).attr('id')));
          $('#xhr_tasks').load("/sys/tasks/" + ($(this).attr('id').split('_')[1]));
          return false;
        });
        $tasks = $('#sidebar.system').on('click', 'ul li a', function() {
          var $url;
          $url = $(this).attr('href');
          Trst.lst.setItem('task_id', $(this).attr('id'));
          $.ajax({
            type: 'POST',
            url: "/sys/session/task_id/" + ($(this).attr('id')),
            async: false
          });
          Trst.desk.init($url);
          return false;
        });
        $helpers = $('#sidebar.system').on('click', 'ul li span', function() {
          $.get("/sys/help/" + ($(this).prev('a').attr('id')), function(data) {
            $('#xhr_content').html(data);
          });
        });
        $helpClose = $('#content').on('click', '#xhr_content p.close', function() {
          $('#xhr_content').load("/sys/page_" + Trst.lst.page_id);
        });
        return $log('Trst.init() OK...');
      }
    });
    return Trst;
  });

}).call(this);
