define () ->
  $.extend Trst.desk.select,
    init: () ->
      $hd   = Trst.desk.hdo
      $form = Trst.desk.hdf
      $form.find('select').each () ->
        $select = $(this)
        $id = $select.attr('id')
        if $id is 'oid'
          $select.select2(
            minimumInputLength: $select.data('minlength'),
            formatInputTooShort: (input, min) ->
              Trst.desk.select.inputTooShortMsg(input, min, $select)
          ) if $select.attr('class') is 's2'
          $select.change ()->
            $hd[$id] = $select.val()
        else
          $msg('Unknown id, select not handled...')
      $msg('Trst.desk.select.init() OK...')
    inputTooShortMsg: (input, min, obj) ->
      msg = "Vă rugăm întroduceţi min. " + (min - input.length) + " caractere" if input.length is 0
      msg = "Vă rugăm întroduceţi incă " + (min - input.length) + " caractere" if input.length isnt 0
      msg = "Vă rugăm întroduceţi incă 1 caracter"  if (min - input.length) is 1
      msg
  return Trst
