(function() {

  define(function() {
    $.extend(true, Trst, {
      desk: {
        select: {
          init: function() {
            var $form, $hd;
            $hd = Trst.desk.hdo;
            $form = Trst.desk.hdf;
            $form.find('select').each(function() {
              var $id, $select;
              $select = $(this);
              $id = $select.attr('id');
              if ($id === 'oid') {
                return $select.change(function() {
                  return $hd[$id] = $select.val();
                });
              } else if ($id && $id.split('_').pop() === 'id') {
                return $select.change(function() {
                  var $url;
                  Trst.lst.setItem('r_mdl', 'fake_mdl');
                  Trst.lst.setItem('r_id', $select.val());
                  $url = "" + ($form.attr('action')) + "/" + $hd.dialog + "?r_id=" + ($select.val());
                  Trst.desk.init($url);
                });
              } else {
                return $log('Unknown id, select not handled...');
              }
            });
            return $log('Trst.desk.select.init() OK...');
          }
        }
      }
    });
    return Trst.desk.select;
  });

}).call(this);
