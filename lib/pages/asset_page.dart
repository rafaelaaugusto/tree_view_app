import 'package:fleasy/fleasy.dart';
import 'package:flutter/material.dart';

import '../components/loading_component.dart';
import '../models/asset_model.dart';
import '../models/location_model.dart';
import '../services/api_service.dart';
import '../utils/filter_builder.dart';
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
  List<LocationModel> locationsData = [];
  List<AssetModel> assetsData = [];
  List<bool> filterSelected = List.filled(2, false);
  TreeNode root = TreeNode.treeDefault();
  TreeNode wholeTree = TreeNode.treeDefault();
  bool hasError = false;
  int resultCount = 0;

  @override
  initState() {
    super.initState();
    fetchDataAndBuildTreeNode();
  }

  Future<void> fetchDataAndBuildTreeNode() async {
    try {
      final locationsFuture = apiService.fetchLocations(widget.companyId);
      final assetsFuture = apiService.fetchAssets(widget.companyId);

      locationsData = await locationsFuture;
      assetsData = await assetsFuture;

      root = buildTree(
        locationsData: locationsData,
        assetsData: assetsData,
      );

      wholeTree = root;
    } catch (e) {
      hasError = true;
    }
    setState(() {});
  }

  void resetFilter() {
    setState(() {
      filterSelected = List.filled(2, false);
      root = wholeTree;
    });
  }

  void selectFilter(int index) {
    resetFilter();
    filterSelected[index] = true;

    if (index == 0) {
      root = filterByEnergySensor(
        locationsData,
        assetsData,
        (result) {
          resultCount = result;
        },
      );
    } else {
      root = filterByCriticalAssets(
        locationsData,
        assetsData,
        (result) {
          resultCount = result;
        },
      );
    }
    setState(() {});
  }

  void filterText(String term) {
    resetFilter();
    root = filterByText(
      locationsData,
      assetsData,
      term,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Assets',
          style: TextStyle(
            fontSize: Insets.xxl,
          ),
        ),
      ),
      body: hasError
          ? const Center(child: Text('Erro ao carregar ativos.'))
          : locationsData.isNotBlank && assetsData.isNotBlank
              ? AssetView(
                  root: root,
                  filterSelected: filterSelected,
                  selectFilter: selectFilter,
                  resetFilter: resetFilter,
                  filterText: filterText,
                  resultCount: resultCount,
                )
              : const Loading(),
    );
  }
}
