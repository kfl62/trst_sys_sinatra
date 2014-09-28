(function() {
  define(function() {
    $.extend(true, Trst, {
      desk: {
        buttons: {
          layout: function(button) {
            var $bd;
            $bd = button.data();
            button.prepend("<i class='" + $bd.icon + "'></i>");
            button.button();
          },
          handle_reload_path: function(button) {
            var $bd, $hd, $params, $url, _ref;
            $hd = Trst.desk.hdo;
            $bd = button.data();
            if ($bd.r_mdl != null) {
              $.ajax({
                type: 'POST',
                url: "/sys/session/r_mdl/" + $bd.r_mdl,
                async: false
              });
              Trst.lst.setItem('r_mdl', $bd.r_mdl);
              Trst.lst.setItem('r_id', $bd.r_id);
              if ($bd.tab) {
                Trst.lst.setItem('tab', $bd.tab);
              }
            }
            if ($bd.r_path != null) {
              if ($bd.r_path === 'remove') {
                $.ajax({
                  type: 'POST',
                  url: "/sys/session/r_path/null",
                  async: false
                });
                Trst.lst.removeItem('r_path');
              } else {
                $.ajax({
                  type: 'POST',
                  url: "/sys/session/r_path/" + ($bd.r_path.replace(/\//g, '!')),
                  async: false
                });
                Trst.lst.setItem('r_path', $bd.r_path);
              }
            }
            if ($bd.url != null) {
              _ref = $bd.url.split('?'), $url = _ref[0], $params = _ref[1];
            } else {
              $url = Trst.desk.hdf.attr('action');
            }
            if (Trst.lst.r_id) {
              $params = $params != null ? "?" + $params + "&r_id=" + Trst.lst.r_id : "?r_id=" + Trst.lst.r_id;
            } else {
              $params = $params != null ? "?" + $params : '';
            }
            return [$url, $params];
          },
          action: {
            create: function() {
              var $bd, $hd, $params, $url, _ref;
              $hd = Trst.desk.hdo;
              $bd = $(this).data();
              _ref = Trst.desk.buttons.handle_reload_path($(this)), $url = _ref[0], $params = _ref[1];
              Trst.desk.closeDesk($bd.remove);
              $url = $url.split('/').pop() === 'create' ? "" + $url + $params : "" + $url + "/create" + $params;
              Trst.desk.init($url);
              return $log('Button.create Pressed...');
            },
            show: function() {
              var $bd, $hd, $params, $url, _ref;
              $hd = Trst.desk.hdo;
              $bd = $(this).data();
              _ref = Trst.desk.buttons.handle_reload_path($(this)), $url = _ref[0], $params = _ref[1];
              $hd.oid = $bd.oid != null ? $bd.oid : $hd.oid;
              if ($hd.oid === null) {
                Trst.publish("msg.select.error", 'error', $hd.model_name);
              } else {
                Trst.desk.closeDesk($bd.remove);
                $url += "/" + $hd.oid + $params;
                Trst.desk.init($url);
              }
              return $log('Button.show Pressed...');
            },
            edit: function() {
              var $bd, $hd, $params, $url, _ref;
              $hd = Trst.desk.hdo;
              $bd = $(this).data();
              _ref = Trst.desk.buttons.handle_reload_path($(this)), $url = _ref[0], $params = _ref[1];
              $hd.oid = $bd.oid != null ? $bd.oid : $hd.oid;
              if ($hd.oid === null) {
                Trst.publish("msg.select.error", 'error', $hd.model_name);
              } else {
                Trst.desk.closeDesk($bd.remove);
                $url = $url.split('/').pop() === 'edit' ? "" + $url + $params : "" + $url + "/edit/" + $hd.oid + $params;
                Trst.desk.init($url);
              }
              return $log('Button.edit Pressed...');
            },
            save: function() {
              var $bd, $data, $hd, $params, $type, $url, _ref;
              $hd = Trst.desk.hdo;
              $bd = $(this).data();
              $type = Trst.desk.hdf.attr('method');
              $data = Trst.desk.hdf.serializeArray();
              _ref = Trst.desk.buttons.handle_reload_path($(this)), $url = _ref[0], $params = _ref[1];
              Trst.desk.closeDesk($bd.remove);
              $hd.oid = $hd.oid === null ? 'create' : $hd.oid;
              $url += "/" + $hd.oid + $params;
              Trst.desk.init($url, $type, $data);
              return $log('Button.save Pressed...');
            },
            "delete": function() {
              var $bd, $hd, $params, $type, $url, _ref;
              $hd = Trst.desk.hdo;
              $bd = $(this).data();
              _ref = Trst.desk.buttons.handle_reload_path($(this)), $url = _ref[0], $params = _ref[1];
              $hd.oid = $bd.oid != null ? $bd.oid : $hd.oid;
              $type = $bd.type != null ? $bd.type : Trst.desk.hdf.attr('method');
              if ($hd.oid === null) {
                Trst.publish("msg.select.error", 'error', $hd.model_name);
              } else {
                Trst.desk.closeDesk($bd.remove);
                if ($hd.dialog === 'delete' || $bd.type === 'delete') {
                  $url += "/" + $hd.oid + $params;
                  Trst.desk.init($url, $type);
                } else {
                  $url = $url.split('/').pop() === 'delete' ? "" + $url + $params : "" + $url + "/delete/" + $hd.oid + $params;
                  Trst.desk.init($url);
                }
              }
              return $log('Button.delete Pressed...');
            },
            cancel: function() {
              var $bd, $url;
              $bd = $(this).data();
              Trst.desk.closeDesk($bd.remove);
              if (Trst.lst.r_mdl) {
                $.ajax({
                  type: 'POST',
                  url: "/sys/session/r_mdl/null",
                  async: false
                });
                Trst.lst.removeItem('r_mdl');
                Trst.lst.removeItem('r_id');
              }
              if (Trst.lst.r_path) {
                $.ajax({
                  type: 'POST',
                  url: "/sys/session/r_path/null",
                  async: false
                });
                $url = Trst.lst.r_path;
                Trst.lst.removeItem('r_path');
                Trst.desk.init($url);
              }
              return $log('Button.cancel Pressed...');
            },
            relations: function() {
              if ($('#relationsContainer').length) {
                $('#relationsContainer').remove();
              } else {

              }
              require(['system/trst_desk_relations'], function(relations) {
                $log('Trst.desk.relations() Loaded...');
                relations.init();
              });
              return $log('Button.relations Pressed...');
            },
            print: function() {
              var $form, $hd;
              $hd = Trst.desk.hdo;
              $form = Trst.desk.hdf;
              Trst.msgShow(Trst.i18n.msg.report.start);
              $.fileDownload("" + ($form.attr('action')) + "/print?id=" + $hd.oid, {
                successCallback: function() {
                  Trst.msgHide();
                },
                failCallback: function() {
                  Trst.msgHide();
                  Trst.desk.createDownload($hd.model_name);
                }
              });
              return $log('Button.print Pressed...');
            }
          },
          init: function(buttons) {
            var $buttons, $desk;
            $desk = $('#deskDialog');
            $buttons = buttons != null ? buttons : $desk.find('button');
            $buttons.each(function() {
              Trst.desk.buttons.layout($(this));
              $(this).on('click', Trst.desk.buttons.action[$(this).data('action')]);
            });
            $desk.find('.buttonset').buttonset();
            return $log('Trst.desk.buttons.init() OK...');
          }
        }
      }
    });
    return Trst.desk.buttons;
  });

}).call(this);
