import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrscanner/src/models/scan_model.dart';
import 'package:qrscanner/src/utils/utils.dart' as utils;

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  final MapController _mapController = MapController();
  final _zoom = 18.0;

  String mapType = "mapbox/streets-v11";

  @override
  Widget build(BuildContext context) {

    final Scan scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title:Text('Coordenadas'),
        actions:[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () => _mapController.move(utils.getLatLong(scan.value), _zoom),
          ),
        ],
      ),
      body: _createMap(scan.value),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.track_changes),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: (){
          switch(mapType){
            case "mapbox/streets-v11": 
              mapType = "mapbox/outdoors-v11";break;
            case "mapbox/outdoors-v11": 
              mapType = "mapbox/light-v10";break;
            case "mapbox/light-v10": 
              mapType = "mapbox/dark-v10";break;
            case "mapbox/dark-v10": 
              mapType = "mapbox/satellite-v9";break;
            case "mapbox/satellite-v9": 
              mapType = "mapbox/satellite-streets-v11";break;
            case "mapbox/satellite-streets-v11": 
              mapType = "mapbox/streets-v11";break;
            default: 
              mapType = "mapbox/streets-v11";
          }
          setState(() {});
        }
      ),
    );
  }

  Widget _createMap(String value) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: utils.getLatLong(value),
        zoom: _zoom,
      ),
      layers: [
        _mapOptions(),
        _createMarkers(value),
      ],
    );
  }

  LayerOptions _mapOptions() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}@2x?access_token={accessToken}',
      additionalOptions: {
        'accessToken':'pk.eyJ1Ijoicm9kcmlnb2xlb25lbCIsImEiOiJja2ZvNTViMzMxbDJ6Mnl0NDFzbGM1d2p3In0.rYLwuOlyU5z9Otthkr01zg',
        'id': mapType
      },
    );
  }

  LayerOptions _createMarkers(String value) {
    return MarkerLayerOptions(
      markers: [
        Marker(
          width: 100,
          height: 100,
          point: utils.getLatLong(value),
          builder: (context) => Icon(
            Icons.location_on,
            size: 45,
            color: Theme.of(context).primaryColor,
          )
        ),
      ],
    );
  }
}