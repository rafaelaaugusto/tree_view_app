import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/asset_model.dart';
import '../models/company_model.dart';
import '../models/location_model.dart';

class ApiService {
  final baseUrl = 'https://fake-api.tractian.com';

  Future<List<CompanyModel>> fetchCompanies() async {
    final response = await http.get(Uri.parse('$baseUrl/companies'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      return data.map((company) => CompanyModel.fromJson(company)).toList();
    } else {
      throw Exception('Failed to load companies');
    }
  }

  Future<List<LocationModel>> fetchLocations() async {
    final response = await http.get(Uri.parse('$baseUrl/companies/locations'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      return data.map((location) => LocationModel.fromJson(location)).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  }

  Future<List<AssetModel>> fetchAssets() async {
    final response = await http.get(Uri.parse('$baseUrl/companies/assets'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      return data.map((asset) => AssetModel.fromJson(asset)).toList();
    } else {
      throw Exception('Failed to load assets');
    }
  }
}
