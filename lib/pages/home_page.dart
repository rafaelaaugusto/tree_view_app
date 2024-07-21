import 'package:fleasy/fleasy.dart';
import 'package:flutter/material.dart';

import '../components/company_card.dart';
import '../models/company_model.dart';
import '../services/api_service.dart';
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
      body: ListView.separated(
        itemCount: companies.length,
        itemBuilder: (context, index) => CompanyCard(
          name: companies[index].name,
          onPressed: () {
            navigateToAssetPage(
              context: context,
              companyId: companies[index].id,
            );
          },
        ),
        padding: const EdgeInsets.symmetric(
          vertical: Insets.xl * 2,
          horizontal: Insets.l * 2,
        ),
        separatorBuilder: (context, index) => const SizedBox(
          height: Insets.l * 2,
        ),
      ),
    );
  }

  void navigateToAssetPage({
    required BuildContext context,
    required String companyId,
  }) {
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
