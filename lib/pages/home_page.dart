import 'package:fleasy/fleasy.dart';
import 'package:flutter/material.dart';

import '../components/company_card.dart';
import '../models/company_model.dart';
import '../services/api_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('TRACTIAN'),
      ),
      body: FutureBuilder<List<CompanyModel>>(
        future: apiService.fetchCompanies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erro'),
            );
          } else {
            final companies = snapshot.data ?? [];

            return ListView.separated(
              itemCount: companies.length,
              itemBuilder: (context, index) => CompanyCard(
                name: companies[index].name,
                onPressed: () {
                  Navigator.pushNamed(context, '/asset');
                },
              ),
              padding: const EdgeInsets.symmetric(
                vertical: Insets.xl * 2,
                horizontal: Insets.l * 2,
              ),
              separatorBuilder: (context, index) => const SizedBox(
                height: Insets.l * 2,
              ),
            );
          }
        },
      ),
    );
  }
}
