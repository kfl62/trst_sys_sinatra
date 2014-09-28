(function() {
  define(function() {
    $.extend(true, Trst, {
      desk: {
        selects: {
          handleOID: function(select) {
            var $form, $hd, $id;
            $hd = Trst.desk.hdo;
            $form = Trst.desk.hdf;
            $id = select.attr('id');
            select.on('change', function() {
              return $hd[$id] = select.val();
            });
          },
          handleRID: function(select) {
            var $form, $hd;
            $hd = Trst.desk.hdo;
            $form = Trst.desk.hdf;
            select.on('change', function() {
              var $url;
              Trst.lst.setItem('r_mdl', 'fake_mdl');
              Trst.lst.setItem('r_id', select.val());
              $url = "" + ($form.attr('action')) + "/" + $hd.dialog + "?r_id=" + (select.val());
              Trst.desk.init($url);
            });
          },
          init: function() {
            this.handleOID($('select#oid'));
            this.handleRID($('select[id$=_id]'));
            return $log('Trst.desk.selects.init() OK...');
          }
        }
      }
    });
    return Trst.desk.selects;
  });

}).call(this);
