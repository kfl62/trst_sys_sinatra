dojo.require("dojo.data.ItemFileReadStore")
dojo.require("dijit.form.FilteringSelect")
dojo.provide("trst.task");
trst.task = {
  // variables {{{1
  id: "",
  verb: "",
  target_id: "",
  url: ["/srv/tsk"],
  connections: new Array,
  actions: new Array,
  taskOverlay: dojo.create('div',{id:"task_overlay"}),
  taskWindow: dojo.create('div',{id:"task_window"}),
  // functions {{{1
  // init {{{2
  init: function(id,verb,target_id){
    this.id = id;
    if (verb == undefined){
      this.verb = "filter"
      this.url.push(this.id,this.verb);
      this[this.verb]()
    }else if (verb == 'help'){
      this.verb = "help"
      this.url.push(this.id,this.verb);
      this[this.verb]()
    }else{
      var referrer = /filter|get/
      if (referrer.test(this.verb)){
        this.url.push(this.id,verb,target_id);
        this.verb = verb;
        this.get();
      }else{
        this.verb = verb;
        this.url.push(this.id,verb,target_id);
        this[this.verb]();
      }
    }
  },
  // filter {{{2
  filter: function(){
    var xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        trst.task.drawBox(data);
        if (dojo.byId('pfFilteringSelect') != undefined){
          trst.task.acc.init(dojo.byId('pfFilteringSelect'));
        }
        dojo.attr('xhr_msg','class','hidden');
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrGet(xhrArgs);
    this.url = ["/srv/tsk"];
  },
  //set unit_id {{{2
  unit_id: function(){
    xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        trst.task.drawBox(data);
        if (dojo.byId('pfFilteringSelect') != undefined){
          trst.task.acc.init(dojo.byId('pfFilteringSelect'));
        }
        dojo.attr('xhr_msg','class','hidden');
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrGet(xhrArgs);
    this.url = ["/srv/tsk"];
  },
  // help {{{2
  help: function(){
    var xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        dojo.byId('xhr_content').innerHTML = data;
        dojo.attr('xhr_msg','class','hidden');
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrGet(xhrArgs);
    this.url = ["/srv/tsk"];
  },
  // get {{{2
  get: function(){
    xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        trst.task.drawBox(data);
        if (dojo.query('[name*="_pn]"]')[0] != undefined){
          trst.task.acc.validPn(dojo.query('[name*="_pn]"]')[0])
        }
        dojo.attr('xhr_msg','class','hidden');
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrGet(xhrArgs);
    this.url = ["/srv/tsk"];
  },
  // pdf get params {{{2
  pdf: function(){
    xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        trst.task.drawBox(data);
        dojo.attr('xhr_msg','class','hidden');
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrGet(xhrArgs);
    this.url = ["/srv/tsk"];
  },
  // pdf generate {{{2
  print: function(){
    xhrArgs = {
      form: dojo.query('form')[0],
      url: this.url.join('/'),
      load: function(data){
        window.location = this.url;
        dojo.attr('xhr_msg','class','hidden');
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrPut(xhrArgs);
    this.destroy();
  },
  //query get params {{{2
  query: function(){
    xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        trst.task.drawBox(data);
        dojo.attr('xhr_msg','class','hidden');
        if (dojo.byId('pfFilteringSelect') != undefined){
          trst.task.acc.init(dojo.byId('pfFilteringSelect'));
        }
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrGet(xhrArgs);
    this.url = ["/srv/tsk"];
  },
  // error handling page {{{2
  repair: function(){
    xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        trst.task.drawBox(data);
        dojo.attr('xhr_msg','class','hidden');
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrGet(xhrArgs);
    this.url = ["/srv/tsk"];
  },
  // not ready page {{{2
  test: function(){
    xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        trst.task.drawBox(data);
        dojo.attr('xhr_msg','class','hidden');
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    dojo.publish('xhrMsg',['loading','info']);
    var deferred = dojo.xhrGet(xhrArgs);
    this.url = ["/srv/tsk"];
  },
  // post {{{2
  post: function(){
    xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        dojo.publish('xhrMsg',['flash']);
        trst.task.drawBox(data);
        if (dojo.byId('freightSelect_01') != undefined){
          trst.task.acc.init(dojo.byId('freightSelect_01'))
        }
        if (dojo.query('[name*="_pn]"]')[0] != undefined){
          trst.task.acc.validPn(dojo.query('[name*="_pn]"]')[0])
        }
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    var deferred = dojo.xhrPost(xhrArgs);
    this.url = ["/srv/tsk"];
  },
  // put {{{2
  put: function(){
    xhrArgs = {
      form: dojo.query('form')[0],
      url: this.url.join('/'),
      load: function(data){
        dojo.publish('xhrMsg',['flash']);
        trst.task.drawBox(data);
        if (dojo.query('[name*="_pn]"]')[0] != undefined){
          trst.task.acc.validPn(dojo.query('[name*="_pn]"]')[0])
        }
     },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    var deferred = dojo.xhrPut(xhrArgs);
    this.url = ["/srv/tsk"];
    this.verb = "get";
  },
  // delete {{{2
  delete: function(){
    xhrArgs = {
      url: this.url.join('/'),
      load: function(data){
        dojo.publish('xhrMsg',['flash']);
      },
      error: function(error){
        dojo.publish('xhrMsg',['error','error',error]);
      }
    };
    var deferred = dojo.xhrDelete(xhrArgs);
    this.destroy();
  },
  // position the taskWindow{{{2
  positionBox: function(o1,o2){
    var lastX,lastY,tskww,tskwh,
    base = dojo.position(o1),
    tskw = dojo.position(o2);
    lastX = base.x + 18;
    lastY = (o2.offsetHeight > 476) ? base.y + (482 - o2.offsetHeight) : base.y + 18;
    dojo.style(o2,{
      left:   lastX + 'px',
      top:    lastY + 'px'
    });
  },
  // draw the taskWindow{{{2
  drawBox: function(data){
    if (dojo.query('[id^="task"]').length == 0){
      var ovl = this.taskOverlay;
      var win = this.taskWindow;
      win.innerHTML = data;
      dojo.place(ovl,dojo.body(),'first');
      dojo.place(win,ovl,'after');
      this.positionBox(dojo.byId('xhr_content'),win);
    }
    else{
      dojo.destroy(dojo.byId('task_window'))
      var ovl = dojo.byId('task_overlay');
      var win = this.taskWindow;
      win.innerHTML = data;
      dojo.place(win,ovl,'after');
    }
  },
  // destroy the taskWindow and reset vars{{{2
  destroy: function(){
    dojo.query('[id^="task"]').forEach("dojo.destroy(item)");
    this.id = this.verb = this.target_id = "";
    this.url = ["/srv/tsk"];
  },
  // connect tasks in sidebar{{{2
  connect: function(){
    dojo.forEach(this.connections, dojo.disconnect);
    this.connections.length = 0;
    dojo.query('#sidebar ul > li > a').forEach(function(a){
      if (a.getAttribute('data-tsks') == 'filter'){
        trst.task.connections.push(
          dojo.connect(a, 'onclick', function(e){
            e.preventDefault()
            trst.task.init(e.target.id)
          })
        )
      }
      else if (a.getAttribute('data-tsks') == 'pdf'){
        trst.task.connections.push(
          dojo.connect(a, 'onclick', function(e){
            e.preventDefault()
            trst.task.init(e.target.id,'pdf')
          })
        )
      }
      else if (a.getAttribute('data-tsks') == 'query'){
        trst.task.connections.push(
          dojo.connect(a, 'onclick', function(e){
            e.preventDefault()
            trst.task.init(e.target.id,'query')
          })
        )
      }
      else if (a.getAttribute('data-tsks') == 'repair'){
        trst.task.connections.push(
          dojo.connect(a, 'onclick', function(e){
            e.preventDefault()
            trst.task.init(e.target.id,'repair','null')
          })
        )
      }
      else if (a.getAttribute('data-tsks') == 'test'){
        trst.task.connections.push(
          dojo.connect(a, 'onclick', function(e){
            e.preventDefault()
            trst.task.init(e.target.id,'test')
          })
        )
      }
    })
  }
}
  // mixin for handling relations {{{2
dojo.mixin(trst.task,{
  relations: {
    relationsOverlay: dojo.create('div',{id:"relations_overlay"}),
    relationsWindow: dojo.create('div',{id:"relations_window"}),
    init: function(node){
      // event.target does't work in firefox
      //this.parentNode = event.target.parentNode;
      this.parentNode = node.parentNode;
      var ovl = this.relationsOverlay,
          win = this.relationsWindow,
          //target = event.target;
          target = node;
      this.url = this.parentNode.children[2].value.split(',');
      // this.url.push(target.dataset.fieldname);
      // dataset not working in firefox
      this.url.push(target.getAttribute('data-fieldname'));
      this.url.push(target.className.split('-').pop());
      var pos = dojo.position(this.parentNode);
      dojo.style(win,{
        left: pos.x + 'px',
        top:  pos.y + 'px'
      });
      dojo.xhrGet({
        url: this.url.join('/'),
        load: function(data){
          win.innerHTML = data;
          dojo.place(ovl,trst.task.taskWindow,'after');
          dojo.place(win,ovl,'after');
        },
        error: function(error){
          trst.task.relations.destroy();
          trst.task.destroy();
          dojo.publish('xhrMsg',['error','error',error]);
        }
      })
    },
    add: function(){
      var span = this.parentNode.children[0],
          names = (span.innerHTML == "") ? [] : span.innerHTML.split(', '),
          input = this.parentNode.children[1],
          ids = (input.value == "") ? [] : input.value.split(','),
          selected = dojo.query('#relations_window option:checked')[0];
      if (selected.value != 'null'){
        names.push(selected.text);
        ids.push(selected.value);
      };
      span.innerHTML = names.join(', ');
      input.value = ids.join(',');
      this.destroy();
    },
    del: function(){
      var span = this.parentNode.children[0],
          names = span.innerHTML.split(', '),
          input = this.parentNode.children[1],
          ids = input.value.split(','),
          selected = dojo.query('#relations_window option:checked')[0];
      if (selected.value != 'null'){
        if (dojo.indexOf(names,selected.text) >= 0)
          names.splice(dojo.indexOf(names,selected.text),1);
        if (dojo.indexOf(ids,selected.value) >= 0)
          ids.splice(dojo.indexOf(ids,selected.value),1);
      };
      span.innerHTML = names.join(', ');
      input.value = ids.join(',');
      this.destroy();
    },
    destroy: function(){
      dojo.query('[id^="relations"]').forEach("dojo.destroy(item)");
      this.url.length = 4;
    }
  }
})
// mixin for embedded documents {{{2
dojo.mixin(trst.task,{
  embedded: {
    filter: function(task_id,step,selected){
      var node = dojo.byId('task_window')
      trst.task.url.push(task_id,'filter');
      var xhrArgs = {
        url: trst.task.url.join('/').concat('?step=',step,'&child_id=',selected),
        load: function(data){
          node.innerHTML = data;
        },
        error: function(error){
          trst.task.destroy();
          dojo.publish('xhrMsg',['error','error',error]);
        }
      };
      var deferred = dojo.xhrGet(xhrArgs);
      trst.task.url = ["/srv/tsk"];
    },
    get: function(task_id,target_id,child_id,target){
      var node = dojo.byId('task_window')
      trst.task.url.push(task_id,'get',target_id);
      var xhrArgs = {
        url: trst.task.url.join('/').concat('?target=',target,'&child_id=',child_id),
        load: function(data){
          node.innerHTML = data;
        },
        error: function(error){
          trst.task.destroy();
          dojo.publish('xhrMsg',['error','error',error]);
        }
      };
      var deferred = dojo.xhrGet(xhrArgs);
      trst.task.url = ["/srv/tsk"];
    }
  }
})
dojo.mixin(trst.task,{
  acc: {
    init: function(input){
      if (input.id == 'pfFilteringSelect'){
        var pfStore = new dojo.data.ItemFileReadStore({
            url: "/utils/search/TrstPartnersPf"
        });
        if (dijit.byId("pfFilteringSelect"))
          dijit.byId("pfFilteringSelect").destroy();
        var id_pn = dojo.query('.filtering-select-pf')[0].getAttribute('data-id_pn')
        var pfSearch = new dijit.form.FilteringSelect({
          id: "pfFilteringSelect",
          name: "id_pn",
          value: (id_pn != undefined) ? id_pn : "",
          store: pfStore,
          searchAttr: "pn",
          placeHolder: "Caută după CNP",
          labelAttr: "label",
          onChange: function(id){
            trst.task.acc.onSelectPf(id)
          }
        },"pfFilteringSelect")
      }else{
        var freightStore = new dojo.data.ItemFileReadStore({
          url: (input.getAttribute('data-dn') == 'true') ? "/utils/search/TrstAccFreight?dn=true" : "/utils/search/TrstAccFreight"
        });
        dojo.query('input.freight').forEach(function(fr,i){
          if (dijit.byId(fr.id))
            dijit.byId(fr.id).destroy();
          var freightSearch = new dijit.form.FilteringSelect({
            id: fr.id,
            name: '[freights][' + (i+1) + '][freight_id]',
            value: "",
            store: freightStore,
            searchAttr: "label",
            placeHolder: "Selectare material",
            labelAttr: "label",
            onChange: function(id){
              if (input.getAttribute('data-dn') == 'true'){
                trst.task.acc.onSelectFreightDN(freightSearch)
              }else{
                trst.task.acc.onSelectFreight(freightSearch)
              }
            }
          },fr.id)
        })
      }
    },
    deliveryInit: function(id){
      var cl = dojo.byId('select_client'),
          tp = dojo.byId('select_transporter');
      trst.task.init(id,'post','new?client_id=' + cl.options(cl.selectedIndex).value + '&transporter_id=' + tp.options(tp.selectedIndex).value)
    },
    grnInit: function(id){
      if (dojo.byId('select_supplier') != undefined){
        var supp = dojo.byId('select_supplier');
        if (selectedValue(supp) != 'null'){
          trst.task.init(id,'post','new?supplier_id=' + selectedValue(supp))
        }else{
          alert("Nu aţi selectat furnizorul!")
        }
      }else if (dojo.byId('grn_supplier_id') != undefined){
        var supp = dojo.byId('grn_supplier_id');
        trst.task.init(id,'post','new?supplier_id=' + supp.value)
      }else{
        alert("Nu aţi selectat furnizorul!")
      }
    },
    onSelectPf: function(id){
      var button = dojo.query('.post')[1] , path = 'new?id_pn=' + id;
      if (button != undefined){
        dojo.connect(button, 'onclick', function(){
          if (dojo.byId('date_retro') != undefined){
            if (dojo.byId('date_retro').checked){
              path += '&date_retro=' + dojo.byId('date_retro').getAttribute('data-date_retro')
            }
          }
          trst.task.init(button.getAttribute('data-task_id'),'post',path)
        })
      }else{
        var task_id = dojo.query('.filtering-select-pf')[0].getAttribute('data-task_id')
        trst.task.init(task_id,'query','?id_pn=' + id)
      }
    },
    onSelectFreight: function(d){
      var tr = d.domNode.parentElement.parentElement
      tr.children[1].children[0].value = d.item.um
      tr.children[2].children[0].value = parseFloat(d.item.pu).toFixed(2)
      tr.children[3].children[0].focus()
      tr.children[3].children[0].select()
    },
    onSelectFreightDN: function(d){
      var tr = d.domNode.parentElement.parentElement
      tr.children[1].children[0].innerHTML = d.item.um
      tr.children[2].children[0].innerHTML = parseFloat(d.item.stock).toFixed(2)
      tr.children[3].children[0].focus()
      tr.children[3].children[0].select()
    },
    onSelectDelegate: function(node){
      if (selectedValue(node) == 'null'){
        alert("Nu este o opţiune validă!")
      }else if (selectedValue(node) == 'new'){
        dojo.destroy(dojo.query('.delegate_select')[0])
        dojo.query('.delegate_new').style('display','')
      }else{
        dojo.query('.delegate_new').forEach(function(tr){
          dojo.destroy(tr)
        })
      }
    },
    deleteRow: function(node){
      dojo.destroy(node.parentElement.parentElement)
      trst.task.acc.calculator();
    },
    deleteRowDN: function(node){
      dojo.destroy(node.parentElement.parentElement)
      trst.task.acc.calculatorDN();
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
    calculatorDN: function(){
      var rows = dojo.query('tbody.inner tr'), v_res = 0, s_qu = 0;
      for(var i=1;i<rows.length -1;i++){
        v_res = (parseFloat(rows[i].children[2].children[0].innerHTML) - parseFloat(rows[i].children[3].children[0].value)).toFixed(2)
        rows[i].children[3].children[0].value = parseFloat(rows[i].children[3].children[0].value).toFixed(2)
        rows[i].children[4].children[0].innerHTML = v_res
        s_qu += parseFloat(rows[i].children[3].children[0].value)
      }
      rows[rows.length -1].children[1].children[0].innerHTML = parseFloat(s_qu).toFixed(2)
    },
    calculatorGrn: function(){
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
    print_expenditure: function(id,verb,target_id){
      trst.task.url.push(id,verb,target_id);
      xhrArgs = {
        url: trst.task.url.join('/'),
        load: function(data){
          window.location = this.url;
          dojo.attr('xhr_msg','class','hidden');
        },
        error: function(error){
          dojo.publish('xhrMsg',['error','error',error]);
        }
      };
      dojo.publish('xhrMsg',['loading','info']);
      var deferred = dojo.xhrGet(xhrArgs);
      trst.task.destroy();
    },
    print_delivery_note: function(id,verb,target_id){
      trst.task.url.push(id,verb,target_id);
      xhrArgs = {
        url: trst.task.url.join('/'),
        load: function(data){
          window.location = this.url;
          dojo.attr('xhr_msg','class','hidden');
        },
        error: function(error){
          dojo.publish('xhrMsg',['error','error',error]);
        }
      };
      dojo.publish('xhrMsg',['loading','info']);
      var deferred = dojo.xhrGet(xhrArgs);
      trst.task.destroy();
    },
    print_grn: function(id,verb,target_id){
      trst.task.url.push(id,verb,target_id);
      xhrArgs = {
        url: trst.task.url.join('/'),
        load: function(data){
          window.location = this.url;
          dojo.attr('xhr_msg','class','hidden');
        },
        error: function(error){
          dojo.publish('xhrMsg',['error','error',error]);
        }
      };
      dojo.publish('xhrMsg',['loading','info']);
      var deferred = dojo.xhrGet(xhrArgs);
      trst.task.destroy();
      // trst.task.id = trst.task.verb = trst.task.target_id = "";
      // trst.task.url = ["/srv/tsk"];

    },
    validPn: function(node){
      if (dijit.byId("delegate_id_pn"))
        dijit.byId("delegate_id_pn").destroy();
      var valid = new dijit.form.ValidationTextBox({
        name: node.name,
        value: node.value,
        required: true,
        trim: true,
        selectOnClick: true,
        placeHolder: "Cod numeric personal",
        promptMessage: "Validare CNP"
      },node)
      dojo.style(valid.domNode,"width","138px");
      if (node.id != "delegate_id_pn")
        valid.focus();
      valid.validator = function(value){
        if (value.length < 13){
          valid.invalidMessage = "Introduceţi 13 cifre!"
          return false
        }else{
          if (value.length > 13){
            valid.invalidMessage = "CNP max. 13 cifre!"
            return false
          }
          var c = new String("279146358279"), sum = 0, mod = 0;
          for(i=0; i<c.length; i++) {
            sum = sum + value.charAt(i) * c.charAt(i)
          }
          mod = sum%11
          if ((mod <10 && mod == value.charAt(12)) || (mod == 10 && value.charAt(12) == 1)){
            valid.displayMessage("CNP valid!")
            return true
          }else{
            valid.invalidMessage = "CNP incorect!"
            return false
          }
        }
      }
    },
    insertRow: function(name,doc_id,freight_id){
      var i = dojo.query('tr.freight').length;
      var lastRow = dojo.query('tr.freight')[i - 1];
      var newRow = dojo.clone(lastRow);
      newRow.children[0].children[0].innerHTML = name;
      newRow.children[2].children[1].name = '[freights][' + i + '][doc_id]'
      newRow.children[2].children[1].value = doc_id
      newRow.children[2].children[2].name = '[freights][' + i + '][freight_id]'
      newRow.children[2].children[2].value = freight_id
      newRow.children[2].children[3].name = '[freights][' + i + '][pu]'
      newRow.children[2].children[3].value = "0.00"
      dojo.destroy(newRow.children[2].children[0])
      newRow.children[3].children[0].name = '[freights][' + i + '][qu]'
      newRow.children[3].children[0].value = "0.00"
      dojo.place(newRow,lastRow,'after')
    }
  }
})
// initialize on load{{{2
function init(){
  trst.task.connect();
}
dojo.addOnLoad(init);
