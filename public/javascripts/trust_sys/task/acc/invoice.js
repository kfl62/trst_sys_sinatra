dojo.mixin(trst.task.acc,{
  invoice: {
    init: function(){
    }
  }
})
    // invoiceInit: function(id){
    //   var cl = dojo.byId('select_client'),
    //       y  = dojo.byId('select_year'),
    //       m  = dojo.byId('select_month'),
    //       t  = dojo.query("[name='out_003']"),
    //       path = 'new';
    //   if (cl && selectedValue(cl) != 'null'){
    //     path += '?client_id=' + selectedValue(cl);
    //   }else{
    //     alert('Nu aţi selectat clientul!')
    //     return false
    //   }
    //   if (y && selectedValue(y) != 'Anul'){
    //     path += '&year=' + selectedValue(y);
    //   }else{
    //     alert('Nu aţi selectat anul!')
    //     return false
    //   }
    //   if (m && selectedValue(m) != 'Luna'){
    //     path += '&month=' + selectedValue(m);
    //   }else{
    //     alert('Nu aţi selectat luna!')
    //     return false
    //   }
    //   path += '&out_003=' + t[0].checked
    //   trst.task.init(id,'query',path)
    // },
    // initInvCpus: function(){
    //   var pus = dojo.query('tr.to-calculate input.pu')
    //   this.cpus = new Object;
    //   if (pus.length > 0){
    //     pus.forEach(
    //       function(pu){
    //         trst.task.acc.cpus[pu.id] = pu.value;
    //       }
    //     )
    //   }
    // },
    // calculatorInv: function(){
    //   var rows = dojo.query('tr.to-calculate'), val = 0, s_val = 0;
    //   if (dojo.query('tr.result').length > 0)
    //     var td_sum = dojo.query('tr.result')[0].children[1];
    //   if (rows.length > 0){
    //     rows.forEach(
    //       function(r){
    //         if (trst.task.acc.cpus != null && trst.task.acc.cpus[r.children[2].children[0].id])
    //           r.children[2].children[0].value = parseFloat(trst.task.acc.cpus[r.children[2].children[0].id]).toFixed(2)
    //         r.children[2].children[0].value = parseFloat( r.children[2].children[0].value).toFixed(2)
    //         val = parseFloat(parseFloat(r.children[1].children[0].innerHTML).toFixed(2) * parseFloat(r.children[2].children[0].value).toFixed(2)).toFixed(2)
    //         r.children[3].children[0].innerHTML = val
    //         s_val += parseFloat(parseFloat(val).toFixed(2))
    //         val = 0
    //       }
    //     )
    //     trst.task.acc.cpus = null;
    //     td_sum.children[0].innerHTML = s_val.toFixed(2)
    //     if (td_sum.children[1])
    //       td_sum.children[1].value = s_val.toFixed(2)
    //   }
    //   if (dojo.byId('payment-payed') && dojo.byId('payment-payed').checked){
    //     var pDoc = dojo.byId('payment-doc')
    //     pDoc.value = 'Achitat cu '
    //     if (dojo.byId('payment-cache').checked){
    //       pDoc.value += 'chitanţa nr. '
    //     }else{
    //       pDoc.value += ' ordin de plată nr. '
    //     }
    //     pDoc.value += dojo.byId('payment-doc-nr').value
    //     pDoc.value += ' din data de '
    //     pDoc.value += dojo.byId('payment-date').value
    //    }
    // },
    // toggleInvoicePayment: function(){
    //   if (dojo.byId('payment-cache').checked){
    //     dojo.byId('payment-payed').checked = true
    //     dojo.byId('payment-doc-label').innerHTML = 'Chitanţa nr.'
    //     dojo.style('payment-doc-nr','display','')
    //     dojo.byId('payment-date-label').innerHTML = ' din data de:'
    //     dojo.byId('payment-date').name = '[trst_acc_invoice][payment_date][]'
    //   }else{
    //     if (dojo.byId('payment-payed').checked){
    //       dojo.byId('payment-doc-label').innerHTML = 'Ordin de plată nr:'
    //       dojo.style('payment-doc-nr','display','')
    //       dojo.byId('payment-date-label').innerHTML = ' din data de:'
    //       dojo.byId('payment-date').name = '[trst_acc_invoice][payment_date][]'
    //     }else{
    //       dojo.byId('payment-doc-label').innerHTML = 'Virament bancar'
    //       dojo.style('payment-doc-nr','display','none')
    //       dojo.byId('payment-date-label').innerHTML = ' termen de plată:'
    //       dojo.byId('payment-date').name = '[trst_acc_invoice][payment_deadline]'
    //     }
    //   }
    // },
    // onSelectDn: function(){
    //   var dns = [], hidden_data = dojo.byId('hidden_data');
    //   var task_id = hidden_data.getAttribute('data-task_id');
    //   var path = 'new'
    //   dojo.query('td.select-dn input:checked').forEach(
    //     function(node){
    //       dns.push(node.id)
    //     }
    //   )
    //   path += '?client_id=' + hidden_data.getAttribute('data-client_id')
    //   path += '&year=' + hidden_data.getAttribute('data-year')
    //   path += '&month=' + hidden_data.getAttribute('data-month')
    //   path += '&out_003=' + hidden_data.getAttribute('data-out_003')
    //   path += '&dn_ary=' + dns
    //   trst.task.acc.initInvCpus();
    //   trst.task.init(task_id,'query', path);
    // },
    // toggleDn: function(node){
    //   var toggle_state = !node.previousElementSibling.checked
    //   node.previousElementSibling.checked = toggle_state
    //   trst.task.acc.onSelectDn()
    // },
