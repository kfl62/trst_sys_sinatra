(function() {
  define(function() {
    $.extend(true, Trst, {
      desk: {
        inputs: {
          handleDownload: function() {
            $('#unit_ids').select2({
              placeholder: 'Selectaţi min. o unitate...',
              minimumInputLength: 0,
              multiple: true,
              data: $('#unit_ids').data('data')
            });
          },
          handleUI: function() {
            $('input[data-mark~=focus]').focus().select().removeClass('ui-state-default');
            $('select[data-mark~=focus]').focus();
            $('input[data-mark~=ui-focus]').each(function() {
              $(this).on('focus', function() {
                $(this).removeClass('ui-state-default');
              });
              $(this).on('blur', function() {
                $(this).addClass('ui-state-default');
              });
            });
            $('input[data-mark~=step]').each(function() {
              $(this).on('keydown', function(e) {
                var $ord, $stp, ref, ref1;
                $stp = $('input[data-mark~=step]');
                $ord = $stp.index(this);
                if ((ref = e.which) === 13 || ref === 34 || ref === 40) {
                  $stp.eq($ord + 1).focus().select();
                }
                if ((ref1 = e.which) === 33 || ref1 === 38) {
                  $stp.eq($ord - 1).focus().select();
                }
              });
            });
            $('input[data-mark~=resize]').each(function() {
              $(this).attr('size', $(this).val().length + 3);
              $(this).on('change', function() {
                $(this).attr('size', $(this).val().length + 3);
              });
            });
          },
          handleIdPN: function() {
            var $input;
            $input = $('input[name*="id_pn"]');
            if ($input.length) {
              $('input[name*="id_pn"]').on('keyup', function() {
                Trst.desk.inputs.handleIdPN();
              });
              if (this.__f.validateIdPN($input.val())) {
                $input.attr('class', 'ui-state-default');
                $input.parents('tr').next().find('input').focus();
              } else {
                $input.attr('class', 'ui-state-error').focus();
              }
            }
          },
          hanedleDatePicker: function(node) {
            var $dp, max, min, now, ref;
            $dp = $(node);
            now = new Date();
            min = Trst.lst.admin === 'true' ? new Date(now.getFullYear(), now.getMonth() - 1, 1) : new Date(now.getFullYear(), now.getMonth(), 1);
            max = '+0';
            $dp.datepicker({
              altField: '#date_send',
              altFormat: 'yy-mm-dd',
              maxDate: max,
              minDate: min,
              regional: ['ro']
            });
            $dp.addClass('ta-ce').attr('size', ((ref = $dp.val()) != null ? ref.length : void 0) + 2);
            $dp.on('change', function() {
              var ref1;
              $dp.attr('size', ((ref1 = $dp.val()) != null ? ref1.length : void 0) + 2);
            });
          },
          __f: {
            validateIdPN: function(id) {
              var $chk, $mod, $sum, fn, i, j;
              $chk = "279146358279";
              $sum = 0;
              fn = function(i) {
                return $sum += id.charAt(i) * $chk.charAt(i);
              };
              for (i = j = 0; j <= 12; i = ++j) {
                fn(i);
              }
              $mod = $sum % 11;
              if (($mod < 10 && $mod.toString() === id.charAt(12)) || ($mod === 10 && id.charAt(12) === "1")) {
                return true;
              } else {
                return false;
              }
            },
            inputTooShortMsg: function(input, min) {
              var $msg;
              if (input.length === 0) {
                $msg = Trst.i18n.msg.input_too_short_strt.replace('%{nr}', min - input.length);
              }
              if (input.length !== 0) {
                $msg = Trst.i18n.msg.input_too_short_more.replace('%{nr}', min - input.length);
              }
              if ((min - input.length) === 1) {
                $msg = Trst.i18n.msg.input_too_short_last;
              }
              return $msg;
            }
          },
          init: function() {
            this.handleUI();
            this.handleIdPN();
            this.hanedleDatePicker($('#date_show'));
            this.handleDownload($('#unit_ids'));
            return $log('Trst.desk.inputs.init() OK...');
          }
        }
      }
    });
    return Trst.desk.inputs;
  });

}).call(this);
