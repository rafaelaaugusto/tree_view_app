class CompanyModel {
  CompanyModel({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory CompanyModel.fromJson(Map<String, dynamic> data) {
    return CompanyModel(
      id: data['id'],
      name: data['name'],
    );
  }
}
