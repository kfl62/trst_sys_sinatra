(function() {
  define(function() {
    $.extend(true, Trst, {
      desk: {
        relations: {
          makeSelectable: function() {
            $('#deskDialog ul.trst-ui-sortable, #relationsContainer ul.trst-ui-sortable').sortable({
              connectWith: '.trst-ui-sortable',
              placeholder: 'ui-state-highlight',
              appendTo: 'body',
              helper: 'clone',
              zIndex: 1010,
              start: function(event, ui) {
                ui.placeholder.height(ui.helper.height);
              }
            }).disableSelection();
          },
          createContainer: function() {
            var $button, $container;
            $button = $('#deskDialog form button[data-action="relations"]');
            $container = $('<div id="relationsContainer"></div>');
            $container.css({
              top: $button.offset().top,
              left: $button.offset().left + $button.width() + 15,
              zIndex: 1005
            });
            return $container;
          },
          init: function() {
            var $button, $form, $hd, $request, $url;
            $hd = Trst.desk.hdo;
            $form = Trst.desk.hdf;
            $button = $('#deskDialog form button[data-action="relations"]');
            $url = "" + ($form.attr('action').replace(/sys/, 'utils/relations')) + "/" + $hd.oid + "/" + ($button.data('rel_to'));
            $request = $.ajax({
              url: $url,
              type: 'GET'
            });
            $request.fail(function(xhr) {
              return Trst.publish('error.desk', 'error', "" + xhr.status + " " + xhr.statusText);
            });
            $request.done(function(data) {
              var $container;
              $container = Trst.desk.relations.createContainer();
              $container.append(data).appendTo('#deskDialog');
              return Trst.desk.relations.makeSelectable();
            });
            return $log('Trst.desk.relations.init() OK...');
          }
        }
      }
    });
    return Trst.desk.relations;
  });

}).call(this);
