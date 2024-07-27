import 'package:fleasy/fleasy.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../models/asset_model.dart';
import '../models/location_model.dart';
import '../theme/colors_theme.dart';

class TreeNode {
  const TreeNode({
    required this.id,
    required this.name,
    required this.children,
    this.leading,
    this.trailing,
  });

  final String id;
  final String name;
  final List<TreeNode> children;
  final Widget? leading;
  final Widget? trailing;

  factory TreeNode.treeDefault() => const TreeNode(
        id: 'root',
        name: 'Root',
        children: [],
      );
}

TreeNode buildTree({
  required List<LocationModel> locationsData,
  required List<AssetModel> assetsData,
  List<AssetModel>? componentsData,
  bool shouldFilter = false,
  String? term,
}) {
  Map<String, TreeNode> nodeMap = {};
  List<TreeNode> rootLocations = [];
  List<TreeNode> rootAssets = [];
  List<TreeNode> rootsComponents = [];

  final assets = assetsData.where((asset) => asset.gatewayId == null).toList();
  final components = componentsData ??
      assetsData.where((component) => component.gatewayId.isNotBlank).toList();

  createTreeNodes(
    nodeMap: nodeMap,
    items: locationsData,
    leading: EvaIcons.pin_outline,
    hasTrailing: false,
    root: rootLocations,
  );
  createTreeNodes(
    nodeMap: nodeMap,
    items: assets,
    leading: EvaIcons.cube_outline,
    root: rootAssets,
  );
  createTreeNodes(
    nodeMap: nodeMap,
    items: components,
    leading: AntDesign.codepen_outline,
    root: rootsComponents,
  );

  assignChildrenToNodes(nodeMap: nodeMap, items: assets);
  assignChildrenToNodes(nodeMap: nodeMap, items: components);

  for (var location in locationsData) {
    if (location.parentId != null && nodeMap.containsKey(location.parentId)) {
      nodeMap[location.parentId!]!.children.add(nodeMap[location.id]!);
    }
  }

  if (shouldFilter || term.isNotBlank) {
    bool removeEmptyNodes(List<TreeNode> rootLocations) {
      bool hasChanged = false;

      if (term.isNotBlank) {
        rootLocations.removeWhere((element) {
          if (element.children.isEmpty &&
              !element.name.toLowerCase().contains(term!)) {
            hasChanged = true;
            return true;
          }
          return false;
        });
      } else {
        rootLocations.removeWhere((element) {
          if (element.children.isEmpty && element.trailing == null) {
            hasChanged = true;
            return true;
          }
          return false;
        });
      }

      for (var root in rootLocations) {
        hasChanged = removeEmptyNodes(root.children) || hasChanged;
      }

      return hasChanged;
    }

    void processTreeNodes(List<TreeNode> rootLocations) {
      bool hasChanged;
      do {
        hasChanged = removeEmptyNodes(rootLocations);
      } while (hasChanged);
    }

    processTreeNodes(rootLocations);
  }

  List<TreeNode> roots = [
    ...rootLocations,
    ...rootAssets,
    ...rootsComponents,
  ].toList();

  return TreeNode(
    id: 'root',
    name: 'Root',
    children: roots,
  );
}

void assignChildrenToNodes({
  required Map<String, TreeNode> nodeMap,
  required List<dynamic> items,
}) {
  for (var item in items) {
    if (item.parentId != null && nodeMap.containsKey(item.parentId)) {
      nodeMap[item.parentId]!.children.add(nodeMap[item.id]!);
    } else if (item.locationId != null &&
        nodeMap.containsKey(item.locationId)) {
      nodeMap[item.locationId]!.children.add(nodeMap[item.id]!);
    }
  }
}

Widget getAssetTrailing(dynamic item) {
  bool isCritical = item.status == Status.alert;

  return Icon(
    isCritical
        ? Icons.circle_rounded
        : item.sensorType != null
            ? FontAwesome.bolt_solid
            : null,
    size: Insets.xl,
    color: isCritical ? criticalIconColor : sensorIconColor,
  );
}

void createTreeNodes({
  required Map<String, dynamic> nodeMap,
  required List<dynamic> items,
  required IconData leading,
  List<dynamic> root = const [],
  bool hasTrailing = true,
}) {
  for (var item in items) {
    TreeNode node = TreeNode(
      id: item.id,
      name: item.name,
      children: [],
      leading: Icon(leading, color: primary),
      trailing: hasTrailing ? getAssetTrailing(item) : null,
    );
    nodeMap[item.id] = node;

    if (item is AssetModel &&
        item.parentId == null &&
        item.locationId == null) {
      root.add(node);
    } else if (item is LocationModel && item.parentId == null) {
      root.add(node);
    }
  }
}
