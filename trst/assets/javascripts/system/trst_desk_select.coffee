define () ->
  $.extend Trst.desk.select,
    init: () ->
      $hd   = Trst.desk.hdo
      $form = Trst.desk.hdf
      $form.find('select').each () ->
        $select = $(this)
        $id = $select.attr('id')
        if $id is 'oid'
          $select.change ()->
            $hd[$id] = $select.val()
        else
          $msg('Unknown id, select not handled...')
      $msg('Trst.desk.select.init() OK...')
  return Trst
