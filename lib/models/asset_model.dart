class AssetModel {
  AssetModel({
    required this.id,
    required this.name,
    this.parentId,
    this.locationId,
    this.sensorType,
    this.status,
  });

  final String id;
  final String name;
  final String? parentId;
  final String? locationId;
  final String? sensorType;
  final String? status;

  factory AssetModel.fromJson(Map<String, dynamic> data) {
    return AssetModel(
      id: data['id'],
      name: data['name'],
      parentId: data['parentId'],
      locationId: data['locationId'],
      sensorType: data['sensorType'],
      status: data['status'],
    );
  }
}
