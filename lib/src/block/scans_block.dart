
import 'dart:async';

import 'package:qrscanner/src/block/validators.dart';
import 'package:qrscanner/src/providers/db_provider.dart';

class ScansBloc with Validators{
  static final ScansBloc _singleton = ScansBloc._();

  //el factory retorna una isntancia o cualquier otra cosa, 
  //me sirve porque voy a retornar algo pribado que seria la instancia
  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc._(){
    // obtener scans de la base de datos al iniciar
    getScans();
  }

  //creamos nuestro streamcontroler como broadcast ya que muchos lo estaran escuchando
  final _scansController = StreamController<List<Scan>>.broadcast();

  //esta sera la referencia al stream
  //Stream<List<Scan>> get scanStream => _scansController.stream;
  //ahora uso streams transformados
  Stream<List<Scan>> get scanStreamHttp => _scansController.stream.transform(httpTransformer);
  Stream<List<Scan>> get scanStreamGeo => _scansController.stream.transform(geoTransformer);

  dispose(){
    _scansController?.close();
  }

  //el codigo que viene se suele poner en otro archivo llamado events,
  //pero en este caso los metodos son simples asi que lo haremos en el mismo block

  getScans() async {
    _scansController.sink.add(await DBProvider.db.getAllScans());
  }
  getScansByType(String type) async {
    _scansController.sink.add(await DBProvider.db.getScanByType(type));
  }
  addScan(Scan scan) async {
    await DBProvider.db.newScan(scan);
    getScans();
  }
  deleteScan(int id) async {
    await DBProvider.db.deleteScan(id);
    getScans();
  }
  deleteAllScans() async {
    await DBProvider.db.deleteAllScans();
    getScans();
  }

}