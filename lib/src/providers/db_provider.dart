
import 'dart:io';

//en ios y android es diferente la direccion donde se guardan los archivos 
//por lo que la libreria path_provider me va a facilitar conocer la ubicacion donde se encuentre
import 'package:path_provider/path_provider.dart';
//path me va a permitir identificar el nombre del archivo
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:qrscanner/src/models/scan_model.dart';
//con esta linea expongo el moldelo a todos los archivos que importen DBProvider
export 'package:qrscanner/src/models/scan_model.dart';

class DBProvider{
  static Database _database;
  static DBProvider db = DBProvider._();

  DBProvider._(); //constructor privado para poder hacer una sola instancia Singleton

  Future<Database> get database async{
    if(_database!=null) return _database;
    else _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //path viene a set el path completo de donde se encuentra el archivo ya se a en ios o android
    final path = join(documentsDirectory.path,'ScanDB.db');

    //ahora creo la base de datos

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async{
        //la base de datos ya esta creada cuando llamo al onCreate, ahora creo las tablas
        await db.execute(
          'CREATE TABLE SCANS ('
          ' id INTEGER PRIMARY KEY,'
          ' type TEXT,'
          ' value TEXT'
          ')'
        );
      }
    );
  }

  //CREAR REGISTROS
  newScanRaw(Scan scan) async {
    final db = await database;
    final res = await db.rawInsert(
      "INSERT INTO SCANS (id,type,value) "
      "VALUES ( ${scan.id}, '${scan.type}', '${scan.value}' )"
    );
    return res;
  }
  newScan(Scan scan) async {
    final db = await database;
    final res = await db.insert('SCANS', scan.toJson());
    return res;
  }

  //SELECT
  Future<Scan> getScan(int id) async{
    final db = await database;
    final res = await db.query('SCANS', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? Scan.fromJson(res.first) : null;
  }
  Future<List<Scan>> getAllScans() async {
    final db = await database;
    final res = await db.query('SCANS');
    return res.isNotEmpty ? res.map((s) => Scan.fromJson(s)).toList() : [];
  }
  Future<List<Scan>> getScanByType(String type) async {
    final db = await database;
    final res = await db.query('SCANS', where: 'type = ?',whereArgs: [type]);
    return res.isNotEmpty ? res.map((s) => Scan.fromJson(s)).toList() :[];
  }

  //UPDATE
  Future<int> updateScan(Scan scan) async {
    final db = await database;
    return await db.update('SCANS',scan.toJson(),where: 'id = ?', whereArgs: [scan.id]);
  }

  //DELETE
  Future<int> deleteScan(int id) async {
    final db = await database;
    return await db.delete('SCANS',where: 'id = ?',whereArgs: [id]);
  }
  Future<int> deleteAllScans() async {
    final db = await database;
    return await db.delete('SCANS');
  }
}