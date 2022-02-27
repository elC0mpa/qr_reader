import 'dart:async';

import '../model/scan.dart';

class ScansTransformer {
  final onlyLocationScans =
      StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
          handleData: (scans, sink) {
    final onlyLocation =
        scans.where((element) => element.type == 'location').toList();
    sink.add(onlyLocation);
  });

  final onlyUrlScans =
      StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
          handleData: (scans, sink) {
    final onlyUrl = scans.where((element) => element.type == 'http').toList();
    sink.add(onlyUrl);
  });
}
