import 'package:fleasy/fleasy.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../components/tree_component.dart';
import '../models/asset_model.dart';
import '../models/location_model.dart';
import '../services/api_service.dart';

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
  TreeNode root =
      TreeNode(id: 'id', name: 'name', children: [], leading: SizedBox());
  String searchTerm = '';
  bool hasError = false;

  @override
  initState() {
    super.initState();
    fetchDataAndBuildTreeNode();
  }

  Future<void> fetchDataAndBuildTreeNode() async {
    try {
      locationsData = await apiService.fetchLocations(widget.companyId);
      assetsData = await apiService.fetchAssets(widget.companyId);
    } catch (e) {
      hasError = true;
    }
    root = buildTreeNode(locationsData, assetsData);
    setState(() {});
  }

  TreeNode buildTreeNode(
    List<LocationModel> locationsData,
    List<AssetModel> assetsData,
  ) {
    Map<String, TreeNode> nodeMap = {};
    final locations =
        locationsData.where((location) => location.parentId == null);
    final assets = assetsData
        .where((asset) => asset.gatewayId == null && asset.sensorType == null);
    final components = assetsData.where(
      (component) => component.gatewayId.isNotBlank,
    );

    for (var location in locationsData) {
      nodeMap[location.id] = TreeNode(
        id: location.id,
        name: location.name,
        children: [],
        leading: const Icon(Icons.local_airport),
      );
    }

    for (var asset in assets) {
      nodeMap[asset.id] = TreeNode(
        id: asset.id,
        name: asset.name,
        children: [],
        leading: Icon(Icons.square),
      );
    }

    for (var component in components) {
      nodeMap[component.id] = TreeNode(
        id: component.id,
        name: component.name,
        children: [],
        leading: Icon(
          Icons.square_foot,
        ),
        trailing: Icon(FontAwesome.bold_solid),
      );
    }

    for (var asset in assets) {
      if (asset.parentId != null && nodeMap.containsKey(asset.parentId)) {
        nodeMap[asset.parentId]!.children.add(nodeMap[asset.id]!);
      } else if (asset.locationId != null &&
          nodeMap.containsKey(asset.locationId)) {
        nodeMap[asset.locationId]!.children.add(nodeMap[asset.id]!);
      }
    }

    for (var component in components) {
      if (component.parentId != null &&
          nodeMap.containsKey(component.parentId)) {
        nodeMap[component.parentId]!.children.add(nodeMap[component.id]!);
      } else if (component.locationId != null &&
          nodeMap.containsKey(component.locationId)) {
        nodeMap[component.locationId]!.children.add(nodeMap[component.id]!);
      }
    }

    for (var location in locationsData) {
      if (location.parentId != null && nodeMap.containsKey(location.parentId)) {
        nodeMap[location.parentId!]!.children.add(nodeMap[location.id]!);
      }
    }

    List<TreeNode> roots = nodeMap.values.where((node) {
      return locations
              .any((loc) => loc.id == node.id && loc.parentId == null) ||
          assets.any((asset) =>
              asset.id == node.id &&
              asset.parentId == null &&
              asset.locationId == null) ||
          components.any((comp) =>
              comp.id == node.id &&
              comp.gatewayId != null &&
              comp.parentId == null &&
              comp.locationId == null);
    }).toList();

    return TreeNode(
      id: 'root',
      name: 'Root',
      children: roots,
      leading: const SizedBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = locationsData.isNotBlank && assetsData.isNotBlank;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
      ),
      body: !hasError
          ? isLoading
              ? Tree(
                  root: root,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )
          : const Center(
              child: Text('Erro ao carregador ativos.'),
            ),
    );
  }
}

class TreeNode {
  const TreeNode({
    required this.id,
    required this.name,
    required this.children,
    required this.leading,
    this.trailing,
  });

  final String id;
  final String name;
  final List<TreeNode> children;
  final Widget leading;
  final Widget? trailing;
}
