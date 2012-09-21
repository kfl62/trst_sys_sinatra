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
            else if Trst.module
              ###
              Handled by Trst.module
              ###
            else
              $log('Unknown id, select not handled...')
          $log('Trst.desk.select.init() OK...')
  Trst.desk.select
