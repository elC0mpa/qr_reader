import 'package:flutter/material.dart';
import 'package:qr_reader/bloc/scans_bloc.dart';
import 'package:qr_reader/providers/db_provider.dart';

import 'directions_page.dart';
import 'locations_page.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScansBloc _scansBloc = ScansBloc();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('QR Reader'),
          actions: [
            IconButton(
                onPressed: () async {
                  _scansBloc.deleteAllScans;
                },
                icon: const Icon(Icons.delete_forever))
          ],
        ),
        body: getBodyFromPage(currentIndex),
        bottomNavigationBar: navigationBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final ScanResult scanResult = await BarcodeScanner.scan();
            if (scanResult.type == ResultType.Barcode) {
              final ScanModel scan = ScanModel(value: scanResult.rawContent);
              await _scansBloc.createScan(scan);
            }
          },
          child: const Icon(Icons.filter_center_focus),
        ));
  }

  Widget getBodyFromPage(int index) {
    switch (index) {
      case 0:
        return LocationsPage();
      case 1:
        return DirectionsPage();
      default:
        return LocationsPage();
    }
  }

  Widget navigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Maps'),
        BottomNavigationBarItem(
            icon: Icon(Icons.streetview), label: 'Directions')
      ],
      onTap: (int index) {
        setState(() {
          currentIndex = index;
        });
      },
      currentIndex: currentIndex,
    );
  }
}
