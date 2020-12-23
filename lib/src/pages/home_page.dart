import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:qrscanner/src/block/scans_block.dart';
import 'package:qrscanner/src/models/scan_model.dart';
import 'package:qrscanner/src/pages/address_page.dart';
import 'package:qrscanner/src/pages/maps_page.dart';
//import 'package:qrscanner/src/providers/db_provider.dart';
import 'package:qrscanner/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scanBloc = ScansBloc();

  int _actualPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('QR Scanner'),
        actions:[IconButton(
          icon: Icon(Icons.delete), 
          onPressed: () => scanBloc.deleteAllScans(),
        )]
      ),
      body: SafeArea(child: _getPage(_actualPage)),
      bottomNavigationBar: _navBar(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _navBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _actualPage,
      onTap: (index){
        setState(() => _actualPage = index,);
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.map),label: 'Mapa'),
        BottomNavigationBarItem(icon: Icon(Icons.directions),label: 'Direcciones'),
      ],
    );
  }

  Widget _getPage(int actual) {
    switch (actual) {
      case 0: return MapsPage(); break;
      case 1: return AddressPage(); break;
      default: return MapsPage();
    }
  }

  _scanQR() async {
    dynamic future ='geo:40.726314534945956,-74.03649702509769';
    final scan = Scan(value: future);
    scanBloc.addScan(scan);
  }

  _scanQR_() async {
    //geo:40.726314534945956,-74.03649702509769
    dynamic future ='';
    
    try{ 
      future = await BarcodeScanner.scan();
      print(future.rawContent);
    }catch(e){ 
      print('Future String: ${e.toString()}');
    }

    if(future!=null){
      final scan = Scan(value: future.rawContent);
      //ya no llamamos a DBProvider porque lo que usaremos es el block que ya lo posee
      //DBProvider.db.newScan(scan);
      scanBloc.addScan(scan);

      // despues de scanear, deseo abrir la pagina, 
      // pero ocurre de que en IOS el tiempo de apertura del scan es muy rapido, 
      // y no abrira la pagina algunas veces
      // asi que vamos a esperar unicamente en IOS 750 miliseconds

      if(Platform.isIOS){
        Future.delayed(Duration(microseconds: 750),(){
          utils.openScan(context,scan);
        });
      }else utils.openScan(context,scan);
    }
  }
}