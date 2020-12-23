

import 'package:flutter/cupertino.dart';
import 'package:qrscanner/src/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong/latlong.dart';

openScan(BuildContext context, Scan scan) async {
  if(scan.type=='http'){
    if (await canLaunch(scan.value)) {
      await launch(scan.value);
    } else {
      throw 'Could not launch ${scan.value}';
    }
  }else{
    Navigator.pushNamed(context, 'map',arguments: scan);
  }
}

LatLng getLatLong(String value){
  final latLong = value.substring(4).split(',');
  return LatLng(double.parse(latLong[0]), double.parse(latLong[1]));
}