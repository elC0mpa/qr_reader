import 'package:flutter/material.dart';
import 'package:qr_reader/bloc/scans_bloc.dart';

import '../model/scan.dart';
import '../utils.dart';

class DirectionsPage extends StatelessWidget {
  DirectionsPage({Key? key}) : super(key: key);
  final ScansBloc _scansBloc = ScansBloc();

  @override
  Widget build(BuildContext context) {
    _scansBloc.getAllScans();
    return StreamBuilder(
        stream: _scansBloc.scansUrlStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<ScanModel>?> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                    background: Container(color: Colors.red),
                    onDismissed: (direction) =>
                        _scansBloc.deleteScan(snapshot.data![index].id as int),
                    key: UniqueKey(),
                    child: ListTile(
                      onTap: () async {
                        if (snapshot.data![index].type == 'http') {
                          launchURL(snapshot.data![index].value);
                        } else {
                          Navigator.pushNamed(context, 'map-coordinates',
                              arguments: snapshot.data![index]);
                        }
                      },
                      leading: const Icon(Icons.cloud_queue),
                      title: Text(snapshot.data![index].value),
                      trailing: const Icon(Icons.arrow_right),
                    ));
              });
        });
  }
}
