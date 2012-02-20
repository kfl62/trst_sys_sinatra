dojo.mixin(trst.task,{
  acc: {
    hd: (dojo.byId('hidden_data') != null) ? dojo.byId('hidden_data').dataset : null,
    init: function(){
      // Update hidden_data
      if (dojo.byId('hidden_data') != null)
        this.hd = dojo.byId('hidden_data').dataset
      // Require js
      if (this.hd){
        if (this.hd.js != undefined){
          if (this.hd.js.split('.')[0] == 'acc'){
            dojo.require('trst.task.' + this.hd.js)
            eval('trst.task.' + this.hd.js + '.init()')
          }
        }
      }
      // Validate pn's
      if (dojo.query('[name*="_pn]"]')[0] != undefined){
        this.validPn(dojo.query('[name*="_pn]"]')[0])
      }
    },
    print: function(id,verb,target_id){
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
      //trst.task.id = trst.task.verb = trst.task.target_id = "";
      //trst.task.url = ["/srv/tsk"];
    },
    validPn: function(node){
      if (dijit.byId("delegate_id_pn"))
        dijit.byId("delegate_id_pn").destroy();
      var valid = new dijit.form.ValidationTextBox({
        name: node.name,
        value: (node.value.indexOf("tmp") != -1) ? "" : node.value,
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
    }
  }
})
