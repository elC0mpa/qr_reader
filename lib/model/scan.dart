import 'dart:convert';
import 'package:latlong2/latlong.dart';

ScanModel scanModelFromJson(String str) => ScanModel.fromJson(json.decode(str));

String scanModelToJson(ScanModel data) => json.encode(data.toJson());

class ScanModel {
  ScanModel({required this.value, this.id}) {
    value.startsWith('http') ? type = 'http' : 'location';
  }

  int? id;
  String type = 'location';
  String value;

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        value: json["value"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "value": value,
      };

  LatLng getCoords() {
    if (type != 'location') {
      return LatLng(0, 0);
    }
    var latlng = value.substring(4, value.indexOf('?')).split(',');

    return LatLng(double.parse(latlng[0]), double.parse(latlng[1]));
  }
}
