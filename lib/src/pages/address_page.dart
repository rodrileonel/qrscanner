import 'package:flutter/material.dart';
import 'package:qrscanner/src/block/scans_block.dart';
import 'package:qrscanner/src/providers/db_provider.dart';
import 'package:qrscanner/src/utils/utils.dart' as utils;

class AddressPage extends StatelessWidget {

  final scanBloc = ScansBloc();
  
  @override
  Widget build(BuildContext context) {
    scanBloc.getScans();

    return StreamBuilder<List<Scan>>(
      stream: scanBloc.scanStreamHttp,
      //stream: DBProvider.db.getAllScans(),
      builder: (BuildContext context, AsyncSnapshot<List<Scan>> snapshot) {
        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }
        if(snapshot.data.length == 0){
          return Center(child:Text('No hay información'));
        }
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context,i) => Dismissible(
            key: UniqueKey(),
            child: ListTile(
              leading:Icon(Icons.cloud, color: Theme.of(context).primaryColor,),
              title: Text(snapshot.data[i].value),
              subtitle: Text(snapshot.data[i].id.toString()),
              trailing: Icon(Icons.keyboard_arrow_right,color: Theme.of(context).primaryColor,),
              onTap: () => utils.openScan(context,snapshot.data[i]),
            ),
            //onDismissed: (direction) => DBProvider.db.deleteScan(snapshot.data[i].id),
            onDismissed: (direction) => scanBloc.deleteScan(snapshot.data[i].id),
          ),
        );
      },
    );
  }
}