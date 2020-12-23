import 'package:latlong/latlong.dart';

class Scan {
  
  int id;
  String type;
  String value;

  Scan({
    this.id,
    this.type,
    this.value,
  }){
    if(value.contains('http'))
      type = 'http';
    else
      type = 'geo';
  }

  factory Scan.fromJson(Map<String, dynamic> json) => Scan(
    id: json["id"],
    type: json["type"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "value": value,
  };

  LatLng getLatLong(){
    final latLong = value.substring(4).split(',');
    return LatLng(double.parse(latLong[0]), double.parse(latLong[0]));
  }
}
