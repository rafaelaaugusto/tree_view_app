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

TreeNode buildTree(
  List<LocationModel> locationsData,
  List<AssetModel> assetsData,
) {
  Map<String, TreeNode> nodeMap = {};
  final assets = assetsData.where((asset) => asset.gatewayId == null).toList();
  final components =
      assetsData.where((component) => component.gatewayId.isNotBlank).toList();

  createTreeNodes(
    nodeMap: nodeMap,
    items: locationsData,
    leading: EvaIcons.pin_outline,
  );
  createTreeNodes(
    nodeMap: nodeMap,
    items: assets,
    leading: EvaIcons.cube_outline,
    hasTrailing: true,
  );
  createTreeNodes(
    nodeMap: nodeMap,
    items: components,
    leading: AntDesign.codepen_outline,
    hasTrailing: true,
  );

  assignChildrenToNodes(nodeMap: nodeMap, items: assets);
  assignChildrenToNodes(nodeMap: nodeMap, items: components);

  for (var location in locationsData) {
    if (location.parentId != null && nodeMap.containsKey(location.parentId)) {
      nodeMap[location.parentId!]!.children.add(nodeMap[location.id]!);
    }
  }

  List<TreeNode> roots = nodeMap.values.where((node) {
    return locationsData
            .any((loc) => loc.id == node.id && loc.parentId == null) ||
        assetsData.any((asset) =>
            asset.id == node.id &&
            asset.parentId == null &&
            asset.locationId == null);
  }).toList();

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
  required Map<String, TreeNode> nodeMap,
  required List<dynamic> items,
  required IconData leading,
  bool hasTrailing = false,
}) {
  for (var item in items) {
    nodeMap[item.id] = TreeNode(
      id: item.id,
      name: item.name,
      leading: Icon(leading, color: primary),
      children: [],
      trailing: hasTrailing ? getAssetTrailing(item) : null,
    );
  }
}
