class LocationModel {
  const LocationModel({
    required this.id,
    required this.name,
    this.parentId,
  });

  final String id;
  final String name;
  final String? parentId;

  factory LocationModel.fromJson(Map<String, dynamic> data) {
    return LocationModel(
      id: data['id'],
      name: data['name'],
      parentId: data['parentId'],
    );
  }
}
