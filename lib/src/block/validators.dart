
import 'dart:async';

import 'package:qrscanner/src/models/scan_model.dart';

class Validators {
  //un StreamTransformer me va a pernitir filtrar cierta data dentro del stream
  //en este caso yo solo quier mostrar informacion de mapas en mapas y geo en geo
  //voya a recibir List<Scan> y tambien voy a retornar un List<Scan>
  final geoTransformer = StreamTransformer<List<Scan>,List<Scan>>.fromHandlers(
    handleData: (scans,sink) {
      //realiz el filtrado de los ementos que tengan como type ='geo'
      final geoScans = scans.where((element) => element.type == 'geo').toList();
      //ahora lo agrego a la tuberia del transformer para que me bote la info filtrada
      sink.add(geoScans);
    },
  );
  //ahora hago lo mismo para firltrar http
  final httpTransformer = StreamTransformer<List<Scan>,List<Scan>>.fromHandlers(
    handleData: (scans,sink) {
      final geoScans = scans.where((element) => element.type == 'http').toList();
      sink.add(geoScans);
    },
  );

}