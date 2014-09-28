(function() {
  define(['system/trst_desk_buttons', 'system/trst_desk_selects', 'system/trst_desk_inputs', 'system/trst_desk_tables'], function() {
    (function($, window, document) {
      return $.widget("app.dialog", $.ui.dialog, {
        options: {
          iconButtons: []
        },
        _create: function() {
          var $titlebar;
          this._super();
          $titlebar = this.uiDialog.find(".ui-dialog-titlebar");
          $.each(this.options.iconButtons, function(i, v) {
            var $button, right;
            $button = $("<button/>").text(this.text);
            right = $titlebar.find("[role='button']:last").css("right");
            $button.button({
              icons: {
                primary: this.icon
              },
              text: false
            }).addClass("ui-dialog-titlebar-close").css("right", (parseInt(right) + 22) + "px").click(this.click).appendTo($titlebar);
          });
        }
      });
    })(jQuery, window, document);
    $.extend(true, $.fn.select2.defaults, {
      formatInputTooShort: function(input, min) {
        return Trst.desk.inputs.__f.inputTooShortMsg(input, min);
      },
      formatSearching: function() {
        return Trst.i18n.msg.searching;
      },
      formatNoMatches: function(term) {
        return Trst.i18n.msg.no_matches;
      }
    });
    $.extend(true, Trst, {
      desk: {
        readData: function() {
          this.hdo = $('#hidden_data').length ? $('#hidden_data').data() : {};
          this.hdf = $('#deskDialog form');
          this.height = $(window).height();
          if (!$.isEmptyObject(this.hdo) && (this.hdf != null)) {
            return true;
          } else {
            return false;
          }
        },
        handleRequires: function() {
          if ($('button').length) {
            this.buttons.init();
          }
          if ($('select').length) {
            this.selects.init();
          }
          if ($('input').length) {
            this.inputs.init();
          }
          if ($('table').length) {
            this.tables.init();
          }
          if (Trst.module != null) {
            Trst.module.desk.init();
          }
        },
        createDesk: function(data) {
          var $desk;
          $desk = $('#deskDialog').length ? $('#deskDialog') : $('<div id="deskDialog"></div>');
          $desk.html(data).dialog({
            dialogClass: 'ui-dialog-trst',
            autoOpen: false,
            resizable: false,
            modal: true,
            minHeight: 10,
            height: 'auto',
            width: 'auto',
            position: {
              my: 'left top',
              at: 'left top',
              of: 'nav',
              collision: 'none'
            },
            close: function() {
              $(this).remove();
            },
            iconButtons: [
              {
                icon: "ui-icon-info",
                click: function(e) {
                  $('#xhr_info').toggle();
                }
              }
            ]
          });
        },
        closeDesk: function(cls) {
          if (cls == null) {
            cls = true;
          }
          if (cls) {
            $('#deskDialog').dialog('close');
            $('[class^="select2"]').remove();
            $('[class^="ui-datepicker"]').remove();
          }
        },
        createDownload: function(data) {
          var $data, $download;
          $download = $('#downloadDialog').length ? $('#downloadDialog') : $('<div id="downloadDialog" class="small"></div>');
          $data = Trst.i18n.msg.report.error.replace('%{data}', data);
          $download.html($data).dialog({
            dialogClass: 'ui-dialog-trst',
            autoOpen: false,
            modal: true,
            height: 'auto',
            width: 'auto',
            position: {
              my: 'left top',
              at: 'left top',
              of: '#menu',
              collision: 'none'
            },
            close: function() {
              $(this).remove();
            },
            title: Trst.i18n.title.report.error
          });
          return $download.dialog('open');
        },
        init: function(url, type, data) {
          var $data, $request, $type, $url;
          $url = url;
          $type = type != null ? type.toUpperCase() : "GET";
          $data = data != null ? data : [];
          $request = $.ajax({
            url: $url,
            type: $type,
            data: $data,
            beforeSend: function() {
              return $('#xhr_msg').html("<span>...</span>").addClass('loading').prepend("<i class='fa fa-refresh fa-spin fa-lg'></i>").show();
            },
            complete: function() {
              return $('#xhr_msg').hide().removeAttr('class').html('');
            }
          });
          $request.fail(function(xhr) {
            Trst.publish('msg.desk.error', 'error', "" + xhr.status + " " + xhr.statusText);
            return false;
          });
          $request.done(function(data) {
            var $desk, $tdata, $title;
            if ($type !== 'GET') {
              Trst.publish('flash');
            }
            if ($type !== 'DELETE') {
              Trst.desk.createDesk(data);
              if (Trst.desk.readData()) {
                $desk = $('#deskDialog');
                $title = Trst.i18n.title[Trst.desk.hdo.dialog][Trst.desk.hdo.js_ext] || Trst.i18n.title[Trst.desk.hdo.dialog]['main'];
                $tdata = Trst.desk.hdo.title_data || Trst.desk.hdo.model_name;
                $desk.dialog({
                  title: $("<span>" + ($title.replace('%{data}', $tdata)) + "</span>").text()
                });
                $desk.dialog('open');
                Trst.desk.handleRequires();
              } else {
                alert(Trst.i18n.msg.session.relogin);
                Trst.lst.clear();
                window.location = '/';
                return $log('Initialize error...');
              }
            } else {
              if (Trst.lst.r_path) {
                $url = Trst.lst.r_path;
                Trst.lst.removeItem('r_path');
                Trst.lst.removeItem('r_mdl');
                Trst.lst.removeItem('r_id');
                Trst.desk.init($url);
              }
            }
          });
          return $log('Trst.desk.init() ...');
        }
      }
    });
    return Trst.desk;
  });

}).call(this);
