(function() {
  define(function() {
    $.extend(true, Trst, {
      desk: {
        tables: {
          handleScroll: function(tbl, h) {
            var $table, tblClmnW, tblCntnr, tblHdr, tblscrll;
            if (h == null) {
              h = 450;
            }
            $table = $(tbl);
            if (h !== 0) {
              tblHdr = $("<table style='width:auto'><tbody class='inner'><tr></tr><tr></tr></tbody></table>");
              tblCntnr = $("<div id='scroll-container' style='height:" + h + "px;overflow-x:hidden;overflow-y:scroll'></div>");
              tblClmnW = [];
              $table.find('tr[data-mark~=scroll] td').each(function(i) {
                tblClmnW[i] = $(this).width();
              });
              tblscrll = $table.find('tr[data-mark~=scroll]').html();
              $table.find('tr[data-mark~=scroll]').html('');
              $table.css('width', 'auto');
              tblHdr.find('tr:first').html(tblscrll);
              tblHdr.find('tr:first td').each(function(i) {
                return $(this).css('width', tblClmnW[i]);
              });
              $table.find('tr[data-mark~=scroll]').next().find('td').each(function(i) {
                $(this).css('width', tblClmnW[i]);
              });
              $table.before(tblHdr);
              $table.wrap(tblCntnr);
            } else {
              tblscrll = $('div#scroll-container').prev().find('tr:first').html();
              $('div#scroll-container').prev().remove();
              $table.find('tr[data-mark~=scroll]').html(tblscrll);
              $table.unwrap();
            }
          },
          handleTab: function() {
            var $tabsDefs;
            $tabsDefs = $('<div id="tabsDefs"><ul></ul></div>');
            $('tbody[id^="tabs-"]').each(function() {
              var $href, $tab;
              $tab = $(this);
              $href = $tab.data('href') ? $tab.data('href') : "#" + ($tab.attr('id'));
              $tabsDefs.find('ul').append("<li><a href='" + $href + "'>" + ($tab.data('title')) + "</a></li>");
              return $(this).appendTo($tabsDefs);
            });
            $('#deskDialog thead').after($tabsDefs);
            $tabsDefs.tabs({
              panelTemplate: '<tbody></tbody>',
              active: Trst.lst.tab ? Trst.lst.tab : 0,
              create: function(event, ui) {
                $('input.focus').focus();
                Trst.lst.removeItem('tab');
              }
            });
          },
          init: function() {
            if ($('table[data-mark~=scroll]').height() > 450) {
              this.handleScroll($('table[data-mark~=scroll]'));
            }
            if ($('tbody[id^="tabs-"]').length) {
              this.handleTab();
            }
            return $log('Trst.desk.tables.init() OK...');
          }
        }
      }
    });
    return Trst.desk.tables;
  });

}).call(this);
