(function() {
  define(function() {
    $.extend(true, Trst, {
      desk: {
        inputs: {
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
                var $ord, $stp, _ref, _ref1;
                $stp = $('input[data-mark~=step]');
                $ord = $stp.index(this);
                if ((_ref = e.which) === 13 || _ref === 34 || _ref === 40) {
                  $stp.eq($ord + 1).focus().select();
                }
                if ((_ref1 = e.which) === 33 || _ref1 === 38) {
                  $stp.eq($ord - 1).focus().select();
                }
              });
            });
            $('input[data-mark~=resize]').each(function() {
              $(this).attr('size', $(this).val().length + 2);
              $(this).on('change', function() {
                $(this).attr('size', $(this).val().length + 2);
              });
            });
          },
          handleIdPN: function() {
            var $input;
            $input = $('input[name*="id_pn"]');
            if ($input.length) {
              if (this.__f.validateIdPN($input.val())) {
                $input.attr('class', 'ui-state-default');
                $input.parents('tr').next().find('input').focus();
              } else {
                $input.attr('class', 'ui-state-error').focus();
              }
            }
          },
          hanedleDatePicker: function(node) {
            var $dp, max, min, now, _ref;
            $dp = $(node);
            now = new Date();
            min = Trst.lst.admin === 'true' ? new Date(now.getFullYear(), now.getMonth() - 1, 1) : new Date(now.getFullYear(), now.getMonth(), 1);
            max = Trst.lst.admin === 'true' ? '+1' : '+0';
            $dp.datepicker({
              altField: '#date_send',
              altFormat: 'yy-mm-dd',
              maxDate: max,
              minDate: min,
              regional: ['ro']
            });
            $dp.addClass('ta-ce').attr('size', ((_ref = $dp.val()) != null ? _ref.length : void 0) + 2);
            $dp.on('change', function() {
              var _ref1;
              $dp.attr('size', ((_ref1 = $dp.val()) != null ? _ref1.length : void 0) + 2);
            });
          },
          __f: {
            validateIdPN: function(id) {
              var $chk, $mod, $sum, i, _fn, _i;
              $chk = "279146358279";
              $sum = 0;
              _fn = function(i) {
                return $sum += id.charAt(i) * $chk.charAt(i);
              };
              for (i = _i = 0; _i <= 12; i = ++_i) {
                _fn(i);
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
            return $log('Trst.desk.inputs.init() OK...');
          }
        }
      }
    });
    return Trst.desk.inputs;
  });

}).call(this);
