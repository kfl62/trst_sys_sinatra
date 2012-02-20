dojo.mixin(trst.task.acc,{
  stock: {
    init: function(){
    }
  }
})
    // insertRow: function(name,doc_id,freight_id){
    //   var i = dojo.query('tr.freight').length, ii = 1;
    //   var lastRow = dojo.query('tr.freight')[i - 1];
    //   var newRow = dojo.clone(lastRow);
    //   newRow.children[0].children[0].innerHTML = name;
    //   (newRow.children[2].children.length) == 4 ? ii = 1 : ii = 0
    //   newRow.children[2].children[ii].name = '[freights][' + i + '][doc_id]'
    //   newRow.children[2].children[ii].value = doc_id
    //   newRow.children[2].children[ii + 1].name = '[freights][' + i + '][freight_id]'
    //   newRow.children[2].children[ii + 1].value = freight_id
    //   newRow.children[2].children[ii + 2].name = '[freights][' + i + '][pu]'
    //   newRow.children[2].children[ii + 2].value = "0.00"
    //   if (ii == 1)
    //     dojo.destroy(newRow.children[2].children[0])
    //   newRow.children[3].children[0].name = '[freights][' + i + '][qu]'
    //   newRow.children[3].children[0].value = "0.00"
    //   dojo.place(newRow,lastRow,'after')
    // }
