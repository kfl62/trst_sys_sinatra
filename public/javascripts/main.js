require.config({
  paths: {
    'jquery': 'http://yandex.st/jquery/1.7.2/jquery.min',
    'jquery-ui': 'http://yandex.st/jquery-ui/1.8.18/jquery-ui.min',
    'async': 'plugins/async'
  },
  priority: ['jquery']
})

require(['jquery','/javascripts/libs/jquery.ba-tinypubsub.min.js'], function($){
  $(function(){
    Trst = {
      desk: {
        buttons: {
          action: {}
        },
        select: {},
        relations: {},
        tabs: {}
      }
    };
    $msg = function(txt){
      if (Trst.debug){
        console.log(txt)
      }
    };
    if ($('body').attr('id') == 'public'){
      require(['public/main'], function(){
        Trst.init()
      })
    } else {
      require(['system/main'], function(){
        Trst.init()
      })
    }
  })
})
