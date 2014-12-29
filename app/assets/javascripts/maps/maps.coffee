# = require jquery

start_xy = null
toolBar = null
steps = null
data = null

initMapMarker = (map, content, location)->
  # 地图上加点
  marker = new AMap.Marker
    icon: "http://webapi.amap.com/images/marker_sprite.png"
    position: location
  marker.setMap(map);

  # 自定义点标记内容
  markerContent = document.createElement("div");
  markerContent.className = "markerContentStyle";

  # 点标记中的图标
  markerImg = document.createElement("img");
  markerImg.className = "markerlnglat";
  markerImg.src = "http://webapi.amap.com/images/0.png";
  markerContent.appendChild(markerImg)

  # 点标记中的文本
  markerSpan = document.createElement("span");
  markerSpan.innerHTML = content;
  markerContent.appendChild(markerSpan);

  marker.setContent(markerContent); # 更新点标记内容
  marker.setPosition(location); # 更新点标记位置

  AMap.event.addListener marker, 'click', ()->
    map.plugin ["AMap.Driving"], ()->
      DrivingOption = {
          policy: AMap.DrivingPolicy.LEAST_TIME
      };
      MDrive = new AMap.Driving(DrivingOption);
      AMap.event.addListener MDrive, "complete", (data)->
        routeS = data.routes;
        if (data.routes.length <= 0)
          alert('未查找到任何结果!')
        else
          initData(map)
          steps = step.steps for step in routeS
          sicon = new AMap.Icon
            image: "http://www.amap.com/images/poi.png"
            size: new AMap.Size(44, 44)
            imageOffset: new AMap.Pixel(-334, -180)

          startmarker = new AMap.Marker
            icon: sicon
            visible: true
            position: start_xy
            map: map
            offset:
              x: -16
              y: -40

          eicon = new AMap.Icon
            image: "http://www.amap.com/images/poi.png"
            size: new AMap.Size(44,44)
            imageOffset: new AMap.Pixel(-334, -134)

          endmarker = new AMap.Marker
            icon: eicon
            visible: true
            position: location
            map: map
            offset:
              x: -16
              y: -40

          extra_path1 = new Array()
          extra_path1.push(start_xy)
          extra_path1.push(steps[0].path[0])
          extra_line1 = new AMap.Polyline
            map: map
            path: extra_path1
            strokeColor: "#9400D3"
            strokeOpacity: 0.7
            strokeWeight: 4
            strokeStyle: "dashed"
            strokeDasharray: [10, 5]

          extra_path2 = new Array()
          path_xy = steps[(steps.length-1)].path
          extra_path2.push(location)
          extra_path2.push(path_xy[(path_xy.length-1)])
          extra_line2 = new AMap.Polyline
            map: map
            path: extra_path2
            strokeColor: "#9400D3"
            strokeOpacity: 0.7
            strokeWeight: 4
            strokeStyle: "dashed"
            strokeDasharray: [10, 5]

          drawpath = new Array()
          for step in steps
            drawpath = step.path
            polyline = new AMap.Polyline
              map: map
              path: drawpath
              strokeColor: "#9400D3"
              strokeOpacity: 0.7
              strokeWeight: 4
              strokeDasharray: [10, 5]

          map.setFitView()
      start_xy = toolBar.getLocation()
      if start_xy == null
        alert('无法定位您的位置！')
      else
        MDrive.search(start_xy, location);
        map.setZoom(15)

initData = (map)->
  map.clearMap()
  if (data != null)
    $(data.maps).each ()->
      initMapMarker(map, this.name, new AMap.LngLat(this.lng, this.lat))
  else
    $.ajax
      url: window.location
      dataType: 'json'
      success: (datas)->
        data = datas
        $(data.maps).each ()->
          initMapMarker(map, this.name, new AMap.LngLat(this.lng, this.lat))



$ ->
  map = new AMap.Map 'map-content'
  initData(map)
  map.plugin ['AMap.ToolBar'], ()->
    toolBar = new AMap.ToolBar
      autoPosition: true
    map.addControl(toolBar)
    toolBar.doLocation()
    AMap.event.addListener toolBar, 'location', (e)->
      map.setZoom(11)
