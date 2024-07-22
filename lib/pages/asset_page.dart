import 'package:fleasy/fleasy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/asset_model.dart';
import '../models/location_model.dart';
import '../services/api_service.dart';
import '../utils/tree_builder.dart';
import '../views/asset_view.dart';

class AssetPage extends StatefulWidget {
  const AssetPage({
    super.key,
    required this.companyId,
  });

  final String companyId;

  @override
  State<AssetPage> createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  final ApiService apiService = ApiService();
  List<bool> filterSelected = List.filled(2, false);
  List<LocationModel> locationsData = [];
  List<AssetModel> assetsData = [];
  late final TreeNode root;
  String searchTerm = '';
  bool hasError = false;

  @override
  initState() {
    super.initState();
    fetchDataAndBuildTreeNode();
  }

  Future<void> fetchDataAndBuildTreeNode() async {
    try {
      locationsData =
          await compute(apiService.fetchLocations, widget.companyId);
      assetsData = await compute(apiService.fetchAssets, widget.companyId);
    } catch (e) {
      hasError = true;
    }
    root = buildTree(locationsData, assetsData);
    setState(() {});
  }

  void applyFilter(int index) {
    filterSelected = List.filled(2, false);
    filterSelected[index] = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
      ),
      body: hasError
          ? const Center(child: Text('Erro ao carregar ativos.'))
          : locationsData.isNotBlank && assetsData.isNotBlank
              ? AssetView(
                  root: buildTree(locationsData, assetsData),
                  filterSelected: filterSelected,
                  applyFilter: applyFilter,
                )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
