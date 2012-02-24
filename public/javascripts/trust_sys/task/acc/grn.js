dojo.mixin(trst.task.acc,{
  grn: {
    init: function(){
      // Validate presence of supplier and connect buttons 'Post'
      if (trst.task.acc.hd.action == 'filter'){
        dojo.query('.button.post.mc-evt').onclick(function(){
          trst.task.acc.grn.validateRequired()
        })
        dojo.query('.button.post.supplier').onclick(function(){
          trst.task.init(trst.task.acc.hd.supplier_task_id,'post','new?partner_type=supplier')
        })
      }
      // Update main_doc_date
      if (trst.task.acc.hd.action == 'put'){
        dojo.query("input[name='[trst_acc_grn][id_date]']").onblur(function(e){
          dojo.query("input[name='[trst_acc_grn][main_doc_date]']")[0].value = e.target.value
        })
      }
      //Initialize select freight inputs
      if (dojo.query('input.freight').length > 0){
        dojo.query('input.freight').forEach(function(fr,i){
          if (dijit.byId(fr.id))
            dijit.byId(fr.id).destroy()
          trst.task.acc.grn.initFreightSearch(fr,i)
        })
      }
      // Connect triggers (qu, pu) inputs to calculator
      var triggers = dojo.query('[id*="qu_"], [id*="qu_"]')
      if (triggers.length > 0){
        triggers.onchange(function(){
          trst.task.acc.grn.calculator()
        })
      }
      // Connect delete row icon
      var drows = dojo.query('span.db-freight-del')
      if (drows.length > 0){
        drows.onclick(function(e){
          trst.task.acc.grn.deleteRow(e.target)
        })
      }
      // Connect buttons ('Save','Cancel','Delete', etc.) except 'Post'
      this.connectButtons()
    },
    validateRequired: function(){
      var sp = dojo.byId('select_supplier');
      if (selectedValue(sp) != 'null'){
        trst.task.init(trst.task.acc.hd.task_id,'post','new?supplier_id=' + selectedValue(sp))
      }else if(dojo.byId('grn_supplier_id') != undefined){
        var spn = dojo.byId('grn_supplier_id')
        trst.task.init(trst.task.acc.hd.task_id,'post','new?supplier_id=' + spn.value)
      }else{
        alert('Nu aţi selectat furnizorul!')
      }
    },
    initFreightSearch: function(fr,i){
      var freightStore = new dojo.data.ItemFileReadStore({
            url: "/utils/search/TrstAccFreight"
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
          trst.task.acc.grn.onSelectFreight(search)
        }
      },fr.id)
    },
    onSelectFreight: function(d){
      var tr = d.domNode.parentElement.parentElement
      tr.children[1].children[0].value = d.item.um
      tr.children[2].children[0].value = parseFloat(d.item.pu).toFixed(2)
      tr.children[3].children[0].focus()
      tr.children[3].children[0].select()
      tr.children[3].children[1].value = d.item.id_stats
    },
    calculator: function(){
      var rows = dojo.query('tbody.inner tr'), v_val = 0, s_val = 0;
      for(var i=1;i<rows.length -1;i++){
        v_val = (parseFloat(rows[i].children[2].children[0].value) * parseFloat(rows[i].children[3].children[0].value)).toFixed(3)
        rows[i].children[2].children[0].value = parseFloat(rows[i].children[2].children[0].value).toFixed(2)
        rows[i].children[3].children[0].value = parseFloat(rows[i].children[3].children[0].value).toFixed(2)
        rows[i].children[4].children[0].innerHTML = parseFloat(v_val).toFixed(2)
        s_val += parseFloat(parseFloat(v_val).toFixed(2));
        v_val = 0
      }
      rows[rows.length -1].children[1].children[0].innerHTML = s_val.toFixed(2)
      rows[rows.length -1].children[1].children[1].value = s_val.toFixed(2)
      dojo.byId('sum_pay').value = s_val.toFixed(2)
    },
    connectButtons: function(){
      var bs = dojo.query('.button.save.mc-evt'),
          bp = dojo.query('.button.print.mc-evt'),
          bc = dojo.query('.button.cancel.mc-evt'),
          bd = dojo.query('.button.delete.mc-evt');
      if (bs.length > 0){
        bs.onclick(function(){
          trst.task.acc.grn.calculator()
          if (dojo.some(dojo.query("select[name*='[trst_acc_grn]'"),function(item){return selectedValue(item) == 'null'})){
            alert('Nu aţi completat toate câmpurile,\n referitoare la furnizor!')
          }else{
            trst.task.init(trst.task.acc.hd.task_id,'put',trst.task.acc.hd.object_id)
          }
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

