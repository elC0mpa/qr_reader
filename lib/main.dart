import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/map_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR-Reader',
      initialRoute: 'home',
      routes: {
        'home': (BuildContext contex) => const HomePage(),
        'map-coordinates': (BuildContext context) => const MapPage()
      },
    );
  }
}
