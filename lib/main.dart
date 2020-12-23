import 'package:flutter/material.dart';
import 'package:qrscanner/src/pages/home_page.dart';
import 'package:qrscanner/src/pages/map_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Scanner',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        //'maps': (BuildContext context) => MapsPage(),
        //'address': (BuildContext context) => AddressPage(),
        'map': (BuildContext context) => MapPage(),
      },
      theme: ThemeData(
        primaryColor: Colors.deepOrange
      ),
    );
  }
}