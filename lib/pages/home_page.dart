import 'package:flutter/material.dart';

import '../models/company_model.dart';
import '../services/api_service.dart';
import '../views/home_view.dart';
import 'asset_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final apiService = ApiService();
  List<CompanyModel> companies = [];

  @override
  void initState() {
    super.initState();
    getCompanies();
  }

  void getCompanies() async {
    companies = await apiService.fetchCompanies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TRACTIAN'),
      ),
      body: HomeView(
        companies: companies,
        navigateToAssetPage: navigateToAssetPage,
      ),
    );
  }

  void navigateToAssetPage(String companyId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AssetPage(
          companyId: companyId,
        ),
      ),
    );
  }
}
