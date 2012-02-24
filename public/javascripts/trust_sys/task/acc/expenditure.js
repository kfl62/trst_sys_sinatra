dojo.mixin(trst.task.acc,{
  expenditure: {
    init: function(){
      // Initialize select by id_pn input
      if (dojo.byId('clientSelect') != null){
        if (dijit.byId("clientSelect"))
          dijit.byId("clientSelect").destroy()
        this.initClientSearch()
      }
      //Initialize select freight inputs
      if (dojo.query('input.freight').length > 0){
        dojo.query('input.freight').forEach(function(fr,i){
          if (dijit.byId(fr.id))
            dijit.byId(fr.id).destroy()
          trst.task.acc.expenditure.initFreightSearch(fr,i)
        })
      }
      // Connect trigger (pu, qu) inputs to calculator
      var triggers = dojo.query('input.pu, input.qu')
      if (triggers.length > 0){
        triggers.onchange(function(){
          trst.task.acc.expenditure.calculator()
        })
      }
      // Connect delete row icon
      var drows = dojo.query('span.db-freight-del')
      if (drows.length > 0){
        drows.onclick(function(e){
          trst.task.acc.expenditure.deleteRow(e.target)
        })
      }
      // Connect buttons ('Save','Cancel','Delete', etc.) except 'Post'
      this.connectButtons()
    },
    initClientSearch: function(){
      var clientStore =  new dojo.data.ItemFileReadStore({
            url: "/utils/search/TrstPartnersPf"
          });
      var id_pn = trst.task.acc.hd.id_pn
      var search = new dijit.form.FilteringSelect({
        id: "clientSelect",
        name: "id_pn",
        value: (id_pn != undefined) ? id_pn : "",
        store: clientStore,
        searchAttr: "pn",
        placeHolder: "Caută după CNP",
        labelAttr: "label",
        invalidMessage: "",
        searchDelay: 500,
        onChange: function(id){
          trst.task.acc.expenditure.onSelectClient(id)
        }
      },"clientSelect")
    },
    onSelectClient: function(id){
      var bpo = dojo.query('.button.post.mc-evt') , path = 'new?id_pn=' + id;
      if (trst.task.acc.hd.action == 'filter'){
        dojo.connect(bpo[0], 'onclick', function(){
          trst.task.init(trst.task.acc.hd.client_task_id,'post','new')
        })
        dojo.connect(bpo[1], 'onclick', function(){
          trst.task.init(trst.task.acc.hd.task_id,'post',path)
        })
      }else{
        trst.task.init(trst.task.acc.hd.task_id,'query','?id_pn=' + id)
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
          trst.task.acc.expenditure.onSelectFreight(search)
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
      var rows = dojo.query('tbody.inner tr'), v_val = 0, v_p03 = 0, v_p16 = 0, v_res = 0, s_val = 0, s_p03 = 0, s_p16 = 0, s_res = 0
      for(var i=1;i<rows.length -1;i++){
        v_val = (parseFloat(rows[i].children[2].children[0].value) * parseFloat(rows[i].children[3].children[0].value)).toFixed(3)
        if (dijit.byId("freightSelect_0"+i).item != null){
          if (dijit.byId("freightSelect_0"+i).item.p03 != 'false'){
            v_p03 = parseFloat((v_val) * 3 / 100).toFixed(3)
          }else{
            v_p03 = 0
          }
        }
        v_p16 = (parseFloat(v_val) * 16 / 100).toFixed(3)
        v_res = parseFloat(parseFloat(v_val).toFixed(2)) - (parseFloat(parseFloat(v_p03).toFixed(2)) + parseFloat(parseFloat(v_p16).toFixed(2)))
        rows[i].children[2].children[0].value = parseFloat(rows[i].children[2].children[0].value).toFixed(2)
        rows[i].children[3].children[0].value = parseFloat(rows[i].children[3].children[0].value).toFixed(2)
        rows[i].children[4].children[0].innerHTML = parseFloat(v_val).toFixed(2)
        rows[i].children[5].children[0].innerHTML = parseFloat(v_p03).toFixed(2)
        rows[i].children[6].children[0].innerHTML = parseFloat(v_p16).toFixed(2)
        rows[i].children[7].children[0].innerHTML = parseFloat(v_res).toFixed(2)
        s_val +=  parseFloat(parseFloat(v_val).toFixed(2)); s_p03 += parseFloat(parseFloat(v_p03).toFixed(2)); s_p16 += parseFloat(parseFloat(v_p16).toFixed(2)); s_res += parseFloat(parseFloat(v_res).toFixed(2));
        v_val = 0; v_p03 = 0; v_p16 = 0; v_res = 0
      }
      rows[rows.length -1].children[1].children[0].innerHTML = s_val.toFixed(2)
      rows[rows.length -1].children[2].children[0].innerHTML = s_p03.toFixed(2)
      rows[rows.length -1].children[3].children[0].innerHTML = s_p16.toFixed(2)
      rows[rows.length -1].children[4].children[0].innerHTML = s_res.toFixed(2)
      rows[rows.length -1].children[1].children[1].value = s_val.toFixed(2)
      rows[rows.length -1].children[2].children[1].value = s_p03.toFixed(2)
      rows[rows.length -1].children[3].children[1].value = s_p16.toFixed(2)
      rows[rows.length -1].children[4].children[1].value = s_res.toFixed(2)
    },
    deleteRow: function(node){
      dojo.destroy(node.parentElement.parentElement)
      this.calculator();
    },
    connectButtons: function(){
      var bs = dojo.query('.button.save.mc-evt'),
          bp = dojo.query('.button.print.mc-evt'),
          bc = dojo.query('.button.cancel.mc-evt'),
          bd = dojo.query('.button.delete.mc-evt');
      if (bs.length > 0){
        bs.onclick(function(){
          trst.task.acc.expenditure.calculator()
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
