import 'dart:async';

import 'package:qr_reader/bloc/scans_transformer.dart';
import 'package:qr_reader/providers/db_provider.dart';

class ScansBloc with ScansTransformer {
  static final ScansBloc _singleton = ScansBloc._();

  final StreamController<List<ScanModel>?> _scansStreamsController =
      StreamController<List<ScanModel>>.broadcast();
  Stream<List<ScanModel>?> get scansLocationStream =>
      _scansStreamsController.stream.transform(onlyLocationScans);
  Stream<List<ScanModel>?> get scansUrlStream =>
      _scansStreamsController.stream.transform(onlyUrlScans);

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._() {
    getAllScans();
  }

  createScan(ScanModel scan) async {
    await DBProvider.db.create(scan);
    getAllScans();
  }

  getAllScans() async {
    _scansStreamsController.sink.add(await DBProvider.db.getAll());
  }

  deleteScan(int id) async {
    await DBProvider.db.deleteById(id);
    getAllScans();
  }

  deleteAllScans() async {
    await DBProvider.db.deleteAll();
    getAllScans();
  }

  dispose() {
    _scansStreamsController.close();
  }
}
