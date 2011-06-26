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
        window.open(this.url);
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
    lastY = base.y + 18;
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
        names.splice(dojo.indexOf(names,selected.text),1);
        ids.splice(dojo.indexOf(selected.value),1);
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
        var pfSearch = new dijit.form.FilteringSelect({
          id: "pfFilteringSelect",
          name: "id_pn",
          value: "",
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
          url: "/utils/search/TrstAccFreight"
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
              trst.task.acc.onSelectFreight(freightSearch)
            }
          },fr.id)
        })
        }
    },
    onSelectPf: function(id){
      var button = dojo.query('.post')[1];
      dojo.connect(button, 'onclick', function(){
        trst.task.init(button.getAttribute('data-task_id'),'post','new?id_pn=' + id)
      })
    },
    onSelectFreight: function(d){
      var tr = d.domNode.parentElement.parentElement
      tr.children[1].children[0].value = d.item.um
      tr.children[2].children[0].value = parseFloat(d.item.pu).toFixed(2)
      tr.children[3].children[0].focus()
      tr.children[3].children[0].select()
    },
    deleteRow: function(node){
      dojo.destroy(node.parentElement.parentElement)
      trst.task.acc.calculator();
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
    print_expenditure: function(id,verb,target_id){
      trst.task.url.push(id,verb,target_id);
      xhrArgs = {
        url: trst.task.url.join('/'),
        load: function(data){
          window.open(this.url);
          dojo.attr('xhr_msg','class','hidden');
        },
        error: function(error){
          dojo.publish('xhrMsg',['error','error',error]);
        }
      };
      dojo.publish('xhrMsg',['loading','info']);
      var deferred = dojo.xhrGet(xhrArgs);
      trst.task.destroy();
    }
  }
})
// initialize on load{{{2
function init(){
  trst.task.connect();
}
dojo.addOnLoad(init);
