(function() {

  define(function() {
    $.extend(true, Trst, {
      desk: {
        tabs: {
          init: function() {
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
            return $log('Trst.desk.tabs.init() OK...');
          }
        }
      }
    });
    return Trst;
  });

}).call(this);
