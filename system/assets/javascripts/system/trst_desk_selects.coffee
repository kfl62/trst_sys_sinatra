define () ->
  $.extend true,Trst,
    desk:
      selects:
        handleOID: (select)->
          $hd   = Trst.desk.hdo
          $form = Trst.desk.hdf
          $id   = select.attr('id')
          select.on 'change', ()->
            $hd[$id] = select.val()
          return
        handleRID: (select)->
          $hd   = Trst.desk.hdo
          $form = Trst.desk.hdf
          select.on 'change', () ->
            Trst.lst.setItem 'r_mdl', 'fake_mdl'
            Trst.lst.setItem 'r_id', select.val()
            $url = "#{$form.attr('action')}/#{$hd.dialog}?r_id=#{select.val()}"
            Trst.desk.init($url)
            return
          return
        init: ()->
          @handleOID($('select#oid'))
          @handleRID($('select[id$=_id]'))
          $log('Trst.desk.selects.init() OK...')
  Trst.desk.selects
