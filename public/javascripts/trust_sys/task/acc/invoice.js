dojo.mixin(trst.task.acc,{
  invoice: {
    init: function(){
      // Validate presence of supplier and connect buttons 'Post'
      if (trst.task.acc.hd.action == 'filter'){
        dojo.query('.button.post.mc-evt').onclick(function(){
          trst.task.acc.invoice.validateRequired()
        })
        dojo.query('.button.post.client').onclick(function(){
          trst.task.init(trst.task.acc.hd.client_task_id,'post','new?partner_type=client')
        })
      }
      // Connect trigger,toggle,calculator,post on select delivery note
      if (trst.task.acc.hd.action == 'query'){
        var trgr = dojo.query('input.trigger'),
            tggl = dojo.query('span.trigger'),
            calc = dojo.query('input.puw'),
            post = dojo.query('.button.post.mc-evt');
        trgr.onchange(function(){
          trst.task.acc.invoice.onDeliveryNoteSelect()
        })
        tggl.onclick(function(e){
          trst.task.acc.invoice.onDeliveryNoteToggle(e.target)
        })
        calc.onchange(function(){
          trst.task.acc.invoice.calculator()
        })
        post.onclick(function(){
          trst.task.acc.invoice.onDeliveryNoteSelectedPost()
        })
        if (this.currentPUs){
          this.calculator()
        }
      }
      // Connect calculator,payment onchange
      if (trst.task.acc.hd.action == 'put'){
        var calc = dojo.query('input.puw'),
            rslt = dojo.query('tr.result'),
            paym = dojo.query('input.payment');
        calc.onchange(function(){
          trst.task.acc.invoice.calculator()
        })
        rslt.onclick(function(){
          trst.task.acc.invoice.calculator()
        })
        paym.onclick(function(){
          trst.task.acc.invoice.togglePayment()
        })
        if (this.currentPUs){
          this.calculator()
        }
      }
     // Connect buttons ('Save','Cancel','Delete', etc.) except 'Post'
      this.connectButtons()
    },
    validateRequired: function(){
      var c = dojo.byId('select_client'),
          y = dojo.byId('select_year'),
          m = dojo.byId('select_month'),
          t  = dojo.query("[name='out_003']"),
          path = 'new';
      if (selectedValue(c) != 'null'){
        path += '?client_id=' + selectedValue(c)
        path += '&year=' + selectedValue(y)
        path += '&month=' + selectedValue(m)
        path += '&out_003=' + t[0].checked
        trst.task.init(trst.task.acc.hd.task_id,'query',path)
      }else{
        alert('Nu aţi selectat clientul!')
      }
    },
    selectedDeliveryNotes: function(){
      var dns = []
      dojo.query('input.trigger:checked').forEach(
        function(node){
          dns.push(node.id)
        }
      )
      return dns
    },
    onDeliveryNoteSelect: function(){
      var path = 'new'
      path += '?client_id=' + trst.task.acc.hd.client_id
      path += '&year=' + trst.task.acc.hd.year
      path += '&month=' + trst.task.acc.hd.month
      path += '&out_003=' + trst.task.acc.hd.out_003
      path += '&dn_ary=' + this.selectedDeliveryNotes()
      this.initCurrentPUs()
      trst.task.init(trst.task.acc.hd.task_id,'query', path);
    },
    onDeliveryNoteToggle: function(node){
      var toggle_state = !node.previousElementSibling.checked
      node.previousElementSibling.checked = toggle_state
      this.onDeliveryNoteSelect()
    },
    onDeliveryNoteSelectedPost: function(){
      var path = 'new'
      path += '?client_id=' + trst.task.acc.hd.client_id
      path += '&dns=' + this.selectedDeliveryNotes()
      this.initCurrentPUs()
      trst.task.init(trst.task.acc.hd.task_id,'post',path)
    },
    initCurrentPUs: function(){
      var cpus = dojo.query('tr.to-calculate input.puw')
      if (cpus.length > 0){
        this.currentPUs = new Object
        cpus.forEach(
          function(pu){
            trst.task.acc.invoice.currentPUs[pu.id] = pu.value;
          }
        )
      }
    },
    calculator: function(){
      var rows = dojo.query('tr.to-calculate'), val = 0, s_val = 0;
      if (dojo.query('tr.result').length > 0)
        var td_sum = dojo.query('tr.result')[0].children[1];
      if (rows.length > 0){
        rows.forEach(
          function(r){
            if (trst.task.acc.invoice.currentPUs != null && trst.task.acc.invoice.currentPUs[r.children[2].children[0].id])
              r.children[2].children[0].value = parseFloat(trst.task.acc.invoice.currentPUs[r.children[2].children[0].id]).toFixed(4)
            r.children[2].children[0].value = parseFloat( r.children[2].children[0].value).toFixed(4)
            val = parseFloat(parseFloat(r.children[1].children[0].innerHTML).toFixed(4) * parseFloat(r.children[2].children[0].value).toFixed(4)).toFixed(2)
            r.children[3].children[0].innerHTML = val
            s_val += parseFloat(parseFloat(val).toFixed(2))
            val = 0
          }
        )
        trst.task.acc.invoice.currentPUs = null;
        td_sum.children[0].innerHTML = s_val.toFixed(2)
        if (td_sum.children[1])
          td_sum.children[1].value = s_val.toFixed(2)
      }
      if (dojo.byId('payment-payed') && dojo.byId('payment-payed').checked){
        var pDoc = dojo.byId('payment-doc')
        pDoc.value = 'Achitat cu '
        if (dojo.byId('payment-cache').checked){
          pDoc.value += 'chitanţa nr. '
        }else{
          pDoc.value += ' ordin de plată nr. '
        }
        pDoc.value += dojo.byId('payment-doc-nr').value
        pDoc.value += ' din data de '
        pDoc.value += dojo.byId('payment-date').value
       }
    },
    togglePayment: function(){
      if (dojo.byId('payment-cache').checked){
        dojo.byId('payment-payed').checked = true
        dojo.byId('payment-doc-label').innerHTML = 'Chitanţa nr.'
        dojo.style('payment-doc-nr','display','')
        dojo.byId('payment-date-label').innerHTML = ' din data de:'
        dojo.byId('payment-date').name = '[trst_acc_invoice][payment_date][]'
      }else{
        if (dojo.byId('payment-payed').checked){
          dojo.byId('payment-doc-label').innerHTML = 'Ordin de plată nr:'
          dojo.style('payment-doc-nr','display','')
          dojo.byId('payment-date-label').innerHTML = ' din data de:'
          dojo.byId('payment-date').name = '[trst_acc_invoice][payment_date][]'
        }else{
          dojo.byId('payment-doc-label').innerHTML = 'Virament bancar'
          dojo.style('payment-doc-nr','display','none')
          dojo.byId('payment-date-label').innerHTML = ' termen de plată:'
          dojo.byId('payment-date').name = '[trst_acc_invoice][payment_deadline]'
        }
      }
    },
    connectButtons: function(){
      var bs = dojo.query('.button.save.mc-evt'),
          bp = dojo.query('.button.print.mc-evt'),
          bc = dojo.query('.button.cancel.mc-evt'),
          bd = dojo.query('.button.delete.mc-evt');
      if (bs.length > 0){
        bs.onclick(function(){
          trst.task.acc.invoice.calculator()
          trst.task.init(trst.task.acc.hd.task_id,'put',trst.task.acc.hd.object_id)
        })
      }
      if (bp.length > 0){
        bp.onclick(function(){
          trst.task.acc.print(trst.task.acc.hd.task_id,'print',trst.task.acc.hd.object_id)
        })
      }
      if (bc.length > 0){
        bc.onclick(function(){
          trst.task.destroy()
        })
      }
      if (bd.length > 0){
        bd.onclick(function(){
          trst.task.init(trst.task.acc.hd.task_id,'delete',trst.task.acc.hd.object_id)
        })
      }
    }
  }
})
