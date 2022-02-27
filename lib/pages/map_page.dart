import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:qr_reader/model/scan.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();

  String mapType = 'dark-v10';

  @override
  Widget build(BuildContext context) {
    final ScanModel _scan =
        ModalRoute.of(context)?.settings.arguments as ScanModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coordinates'),
        actions: [
          IconButton(
              onPressed: () {
                _mapController.move(_scan.getCoords(), 10);
              },
              icon: const Icon(Icons.my_location))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.repeat),
        onPressed: () {
          setState(() {
            if (mapType == 'dark-v10') {
              mapType = 'streets-v11';
            } else {
              mapType = 'dark-v10';
            }
          });
        },
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _scan.getCoords(),
          zoom: 10,
        ),
        layers: [createMap(), createMarkers(_scan)],
      ),
    );
  }

  TileLayerOptions createMap() {
    return TileLayerOptions(
        urlTemplate:
            "https://api.mapbox.com/styles/v1/mapbox/{style_id}/tiles/{z}/{x}/{y}?access_token={accessToken}",
        additionalOptions: {
          'accessToken':
              'pk.eyJ1IjoiZWxjMG1wYSIsImEiOiJjbDA0bTU5dTgxZnNwM2NucHN1b3F0YWI5In0.M285SJ3AzXQRs9bn3D0TUw',
          'style_id': mapType,
        });
  }

  MarkerLayerOptions createMarkers(ScanModel _scan) {
    return MarkerLayerOptions(markers: [
      Marker(
          width: 100,
          height: 100,
          point: _scan.getCoords(),
          builder: (BuildContext context) {
            return const Icon(
              Icons.location_on,
              size: 50,
            );
          })
    ]);
  }
}
