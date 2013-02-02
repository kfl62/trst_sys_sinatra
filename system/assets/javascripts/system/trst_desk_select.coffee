define () ->
  $.extend true,Trst,
    desk:
      select:
        init: () ->
          $hd   = Trst.desk.hdo
          $form = Trst.desk.hdf
          $form.find('select').each () ->
            $select = $(this)
            $id = $select.attr('id')
            if $id is 'oid'
              $select.change ()->
                $hd[$id] = $select.val()
            else if $id and $id.split('_').pop() is 'id'
              $select.change () ->
                Trst.lst.setItem 'r_mdl', 'fake_mdl'
                Trst.lst.setItem 'r_id', $select.val()
                $url = "#{$form.attr('action')}/#{$hd.dialog}?r_id=#{$select.val()}"
                Trst.desk.init($url)
                return
            else
              $log('Unknown id, select not handled...')
          $log('Trst.desk.select.init() OK...')
  Trst.desk.select
