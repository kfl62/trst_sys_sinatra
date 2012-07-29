dojo.mixin(trst.task.acc,{
  cassation: {
    init: function(){
      // Connect select, 'Post' on filter
      if (trst.task.acc.hd.action == 'filter'){
        dojo.query('select.pv').onchange(function(e){
          if (selectedValue(e.target) != 'null'){
            trst.task.init(trst.task.acc.hd.task_id,'get',selectedValue(e.target))
          }
        })
        dojo.query('.button.post.mc-evt').onclick(function(){
           trst.task.init(trst.task.acc.hd.task_id,'post','new')
        })
      }
      //Initialize select freight inputs
      if (dojo.query('input.freight').length > 0){
        dojo.query('input.freight').forEach(function(fr,i){
          if (dijit.byId(fr.id))
            dijit.byId(fr.id).destroy()
          trst.task.acc.cassation.initFreightSearch(fr,i)
        })
      }
      // Connect trigger (qu) inputs to calculator
      var triggers = dojo.query('[id*="qu_"]')
      if (triggers.length > 0){
        triggers.onchange(function(){
          trst.task.acc.cassation.calculator()
        })
      }
      // Connect delete row icon
      var drows = dojo.query('span.db-freight-del')
      if (drows.length > 0){
        drows.onclick(function(e){
          trst.task.acc.cassation.deleteRow(e.target)
        })
      }
      // Connect buttons ('Save','Cancel','Delete', etc.) except 'Post'
      this.connectButtons()
    },
    initFreightSearch: function(fr,i){
      var freightStore = new dojo.data.ItemFileReadStore({
            url: "/utils/search/TrstAccFreight?dn=true"
          })
      var search = new dijit.form.FilteringSelect({
        id: fr.id,
        name: '[freights][' + (i+1) + '][freight_id]',
        value: "",
        store: freightStore,
        searchAttr: "label",
        placeHolder: "Selectare material",
        labelAttr: "label",
        onChange: function(id){
          trst.task.acc.cassation.onSelectFreight(search)
        }
      },fr.id)
    },
    onSelectFreight: function(d){
      var tr = d.domNode.parentElement.parentElement
      tr.children[1].children[0].innerHTML = d.item.um
      tr.children[2].children[0].innerHTML = parseFloat(d.item.stock).toFixed(2)
      tr.children[3].children[0].focus()
      tr.children[3].children[0].select()
      tr.children[3].children[2].value = d.item.id_stats
    },
    calculator: function(){
      var rows = dojo.query('tbody.inner tr'), v_res = 0, s_qu = 0;
      for(var i=1;i<rows.length -1;i++){
        v_res = (parseFloat(rows[i].children[2].children[0].innerHTML) - parseFloat(rows[i].children[3].children[0].value)).toFixed(2)
        if (v_res < 0){
          var v_stock = parseFloat(rows[i].children[2].children[0].innerHTML).toFixed(2),
              v_out   = parseFloat(rows[i].children[3].children[0].value).toFixed(2),
              v_text  = 'Cantitatea introdusă este mai mare decât stocul disponibil!\n';
          v_text += 'În cazul în care puteţi modifica cantitatea pe Aviz, apăsaţi \"Ok\"\n'
          v_text += 'şi modificaţi avizul cu cantitatea corectă! (' + v_stock + 'kg)\n'
          v_text += 'În caz contrar apăsaţi \"Cancel\"! Anexa se va şterge şi o puteţi \n'
          v_text += 'reface după ce faceţi o intrare de cel puţin (' + (0 - v_res).toFixed(2) + 'kg).'
          if (confirm(v_text)){
            rows[i].children[3].children[0].value = v_stock
            rows[i].children[4].children[0].innerHTML = '0.00'
          }else{
            rows[i].children[3].children[0].value = 0.00
            trst.task.init(trst.task.acc.hd.task_id,'delete',trst.task.acc.hd.object_id)
          }
        }else{
          rows[i].children[3].children[0].value = parseFloat(rows[i].children[3].children[0].value).toFixed(2)
          rows[i].children[4].children[0].innerHTML = v_res
        }
        s_qu += parseFloat(rows[i].children[3].children[0].value)
      }
      rows[rows.length -1].children[1].children[0].innerHTML = parseFloat(s_qu).toFixed(2)
    },
    deleteRow: function(node){
      dojo.destroy(node.parentElement.parentElement)
      this.calculator();
    },
    validateInputs: function(){
      if (dojo.query('[name*="[id_main_doc]"]')[0].value.length < 5){
        if (confirm('Numărul Avizului este corect?')){
          if (selectedValue(dojo.query('[name*="[id_delegate_t]"]')[0]) == 'null'){
            alert('Nu aţi selectat delegatul!')
          }else{
            return true
          }
        }
      }
      else if (selectedValue(dojo.query('[name*="[id_delegate_t]"]')[0]) == 'null'){
        alert('Nu aţi selectat delegatul!')
      }
      else{
        return true
      }
    },
    connectButtons: function(){
      var bs = dojo.query('.button.save.mc-evt'),
          bc = dojo.query('.button.cancel.mc-evt'),
          bd = dojo.query('.button.delete.mc-evt');
      if (bs.length > 0){
        bs.onclick(function(){
          trst.task.acc.cassation.calculator()
          trst.task.init(trst.task.acc.hd.task_id,'put',trst.task.acc.hd.object_id)
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
