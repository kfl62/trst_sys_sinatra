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
