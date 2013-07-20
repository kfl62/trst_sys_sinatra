(function() {

  define(['async!http://maps.google.com/maps/api/js?sensor=false'], function() {
    $.extend(true, Trst, {
      gmap: function(node) {
        var latlng, map, marker, myOptions;
        latlng = new google.maps.LatLng(46.74479, 23.43220);
        myOptions = {
          zoom: 15,
          center: latlng,
          scaleControl: false,
          mapTypeId: google.maps.MapTypeId.HYBRID
        };
        map = new google.maps.Map(node, myOptions);
        marker = new google.maps.Marker({
          position: latlng,
          map: map,
          title: "kfl62"
        });
      }
    });
    return Trst;
  });

}).call(this);
