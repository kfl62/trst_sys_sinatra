define () ->
  $.extend true,Trst,
    desk:
      inputs:
        handleUI: ()->
          $('input[data-mark~=focus]').focus().select().removeClass 'ui-state-default'
          $('select[data-mark~=focus]').focus()
          $('input[data-mark~=ui-focus]').each ()->
            $(@).on 'focus',()-> $(@).removeClass 'ui-state-default'; return
            $(@).on 'blur', ()-> $(@).addClass 'ui-state-default'; return
            return
          $('input[data-mark~=step]').each ()->
            $(@).on 'keydown', (e)->
              $stp = $('input[data-mark~=step]'); $ord = $stp.index(@)
              $stp.eq($ord + 1).focus().select() if e.which in [13,34,40]
              $stp.eq($ord - 1).focus().select() if e.which in [33,38]
              return
            return
          $('input[data-mark~=resize]').each ()->
            $(@).attr 'size', $(@).val().length + 2
            $(@).on 'change', ()->
              $(@).attr 'size', $(@).val().length + 2
              return
            return
          return
        handleIdPN: ()->
          $input = $('input[name*="id_pn"]')
          if $input.length
            if @__f.validateIdPN($input.val())
              $input.attr('class','ui-state-default')
              $input.parents('tr').next().find('input').focus()
            else
              $input.attr('class','ui-state-error').focus()
          return
        hanedleDatePicker: (node)->
          $dp = $(node)
          now = new Date()
          min = if Trst.lst.admin is 'true' then new Date(now.getFullYear(),now.getMonth() - 1,1) else new Date(now.getFullYear(),now.getMonth(),1)
          max = if Trst.lst.admin is 'true' then '+1' else '+0'
          $dp.datepicker
            altField: '#date_send'
            altFormat: 'yy-mm-dd'
            maxDate: max
            minDate: min
            regional: ['ro']
          $dp.addClass('ta-ce').attr 'size', $dp.val()?.length + 2
          $dp.on 'change', ()->
            $dp.attr 'size', $dp.val()?.length + 2
            return
          return
        __f:
          validateIdPN: (id)->
            $chk = "279146358279"
            $sum = 0
            for i in [0..12]
              do (i)->
                $sum += id.charAt(i) * $chk.charAt(i)
            $mod = $sum % 11
            if ($mod < 10 and $mod.toString() is id.charAt(12)) or ($mod is 10 and id.charAt(12) is "1") then true else false
          inputTooShortMsg: (input, min)->
            $msg = Trst.i18n.msg.input_too_short_strt.replace '%{nr}', (min - input.length) if input.length is 0
            $msg = Trst.i18n.msg.input_too_short_more.replace '%{nr}', (min - input.length) if input.length isnt 0
            $msg = Trst.i18n.msg.input_too_short_last if (min - input.length) is 1
            $msg
        init: ()->
          @handleUI()
          @handleIdPN()
          @hanedleDatePicker $('#date_show')
          $log('Trst.desk.inputs.init() OK...')
  Trst.desk.inputs
