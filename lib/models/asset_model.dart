import 'package:fleasy/fleasy.dart';

class AssetModel {
  AssetModel({
    required this.id,
    required this.name,
    this.parentId,
    this.locationId,
    this.sensorType,
    this.status,
    this.gatewayId,
  });

  final String id;
  final String name;
  final String? parentId;
  final String? locationId;
  final SensorType? sensorType;
  final Status? status;
  final String? gatewayId;

  factory AssetModel.fromJson(Map<String, dynamic> data) {
    final sensorType = data['sensorType'] != null
        ? SensorType.values.find((sensor) => sensor.name == data['sensorType'])
        : null;

    final status = data['status'] != null
        ? Status.values.find((status) => status.name == data['status'])
        : null;

    return AssetModel(
      id: data['id'],
      name: data['name'],
      parentId: data['parentId'],
      locationId: data['locationId'],
      sensorType: sensorType,
      status: status,
      gatewayId: data['gatewayId'],
    );
  }
}

enum SensorType {
  vibration,
  energy;
}

enum Status {
  alert,
  operanting;
}
