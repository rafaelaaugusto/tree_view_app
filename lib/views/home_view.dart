import 'package:fleasy/fleasy.dart';
import 'package:flutter/material.dart';

import '../components/company_card_component.dart';
import '../models/company_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    required this.companies,
    required this.navigateToAssetPage,
  });

  final List<CompanyModel> companies;
  final Function(String companyId) navigateToAssetPage;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: companies.length,
      itemBuilder: (context, index) {
        return CompanyCard(
          name: companies[index].name,
          onPressed: () {
            navigateToAssetPage(
              companies[index].id,
            );
          },
        );
      },
      padding: const EdgeInsets.symmetric(
        vertical: Insets.xl * 2,
        horizontal: Insets.l * 2,
      ),
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: Insets.l * 2,
        );
      },
    );
  }
}
