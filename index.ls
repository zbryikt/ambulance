angular.module \main, <[]>
  ..controller \main, <[$scope $http]> ++ ($scope, $http) ->
    (err,pal) <- loading.palette \http://loading.io/palette/5596284057e89426548d6eb7, _
    console.log pal.ordinal
    <- $scope.$apply
    src = \台北市北投區建民路116巷11號
    des = \台北車站
    map-style = [
      {
        "featureType": "water",
        "stylers": [
          { "color": \#fbfbfb }
        ]
      },{
        "featureType": "landscape",
        "stylers": [
          { "color": \#d1d1d1 }
        ]
      },{
        "featureType": "road",
        "stylers": [
          { "color": \#999999 },
          { "visibility": "simplified" }
        ]
      },{
        "featureType": "poi",
        "stylers": [
          { "color": \#979797 },
          { "visibility": "simplified" }
        ]
      },{
      }
    ]

    map-option = do
      center: new google.maps.LatLng 25.124146, 121.420623
      zoom: 13
      minZoom: 8
      maxZoom: 18
      mapTypeId: google.maps.MapTypeId.ROADMAP
      panControlOptions: position: google.maps.ControlPosition.LEFT_CENTER
      zoomControlOptions: position: google.maps.ControlPosition.LEFT_CENTER
      mapTypeControlOptions: position: google.maps.ControlPosition.LEFT_CENTER

    map = new google.maps.Map document.getElementById(\map), map-option
      ..set \styles, map-style
    list = [
      #"臺北市大安區仁愛路四段266巷6號",
      #"臺北市中山區中山北路二段92號",
      "臺北市文山區興隆路三段111號",
    ]
    list = [
      "臺北市大安區仁愛路四段266巷6號",
      "臺北市中山區中山北路二段92號",
      "臺北市文山區興隆路三段111號",
      "臺北市內湖區成功路二段325號",
      "臺北市北投區石牌路二段201號",
      "臺北市中正區中山南路7號",
      "臺北市士林區文昌路95號",
      "臺北市松山區八德路二段424",
      "臺北市信義區吳興街252號",
      "臺北市大安區仁愛路四段10號",
      "臺北市大同區鄭州路145號",
      "臺北市南港區同德路87號",
      "臺北市士林區雨聲街105號",
    ]

    list = <[ 臺北市大安區仁愛路四段266巷6號 臺北市中山區中山北路二段92號 臺北市文山區興隆路三段111號 臺北市內湖區成功路二段325號 臺北市北投區石牌路二段201號 臺北市中正區中山南路7號 臺北市士林區文昌路95號 臺北市松山區八德路二段424 臺北市信義區吳興街252號 臺北市大安區仁愛路四段10號 臺北市大同區鄭州路145號 臺北市南港區同德路87號 臺北市士林區雨聲街105號 臺北市中正區中華路二段33號 臺北市北投區振興街45號 臺北市松山區敦化北路199號 臺北市內湖區成功路五段420巷26號 臺北市松山區健康路131號 臺北市內湖區內湖路二段360號 臺北市松山區光復北路66-68號 臺北市萬華區西園路二段270號 新北市中和區中正路291號 新北市板橋區南雅南路二段21號 新北市新店區建國路289號 新北市新店區中正路362號 新北市汐止區建成路59巷2號 新北市淡水區民生路45號 新北市永和區中興街80號 新北市三峽區復興路399號 新北市新莊區思源路127號 新北市板橋區忠孝路15號 新北市新莊區新泰路157號 新北市樹林區文化街9號 新北市金山區五湖里南勢51號 新北市三重區中山路2號 新北市瑞芳區一坑路71之2號 新北市新莊區中正路794號 桃園縣龜山鄉公西村復興街5號、5之7號 桃園縣平鎮市廣泰路77號 桃園縣龍潭鄉中興路168號 桃園縣桃園市建新街123號 桃園縣桃園市中山路1492號 桃園縣桃園市成功路三段100號 桃園縣桃園市經國路168號 桃園縣中壢市延平路155號 桃園縣楊梅市中山北路一段356號 桃園縣楊梅市楊新北路321巷30號 桃園縣新屋鄉新褔二路6號]>

    $scope.elapsed = []
    $scope.count = 0
    calc = (src,des)->
      $scope.elapsed = []
      [src,des] = [src,des]map(->encodeURIComponent it)
      $http do
        url: "http://crossorigin.me/http://maps.googleapis.com/maps/api/directions/json?origin=#{src}&destination=#{des}"
        method: \GET
      .success (response) ->
        $scope.count += 1
        console.log response
        elapsed = 0
        polyline = new google.maps.Polyline do
          path: []
          stroke-color: pal.ordinal $scope.count #\#ff0000
          stroke-weight: 7
        bounds = new google.maps.LatLngBounds!
        if !response.routes.0 => return
        legs = response.routes.0.legs
        for i from 0 til legs.length
          steps = legs[i].steps
          elapsed += legs[i].duration.value
          for j from 0 til steps.length
            str = "#{steps[j].polyline.points}"
            points = google.maps.geometry.encoding.decodePath(str)
            for k from 0 til points.length =>
              polyline.get-path!push points[k]
              bounds.extend points[k]
        polyline.set-map map
        map.fit-bounds bounds
        $scope.elapsed.push elapsed
    #for item in list
    #  calc \台北市北投區建民路116巷11號, item
    $scope.$watch 'elapsed', (->
      $scope.avg-elapsed = parseInt(( $scope.elapsed.reduce(((a,b)-> a + b),0) / $scope.elapsed.length ) / 60)
    ), true
    google.maps.event.addListener map, \click, (e) ->
      ll = e.latLng
      src = "#{ll.lat!},#{ll.lng!}"
      for item in list
        calc src, item

