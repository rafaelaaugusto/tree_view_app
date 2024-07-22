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
    required this.leading,
    this.trailing,
  });

  final String id;
  final String name;
  final List<TreeNode> children;
  final Widget leading;
  final Widget? trailing;
}

TreeNode buildTree(
  List<LocationModel> locationsData,
  List<AssetModel> assetsData,
) {
  Map<String, TreeNode> nodeMap = {};

  final assets = assetsData.where(
    (asset) => asset.gatewayId == null,
  );
  final components = assetsData.where(
    (component) => component.gatewayId.isNotBlank,
  );

  for (var location in locationsData) {
    nodeMap[location.id] = createTreeNode(
      id: location.id,
      name: location.name,
      iconData: EvaIcons.pin_outline,
    );
  }

  for (var asset in assets) {
    nodeMap[asset.id] = createTreeNode(
      id: asset.id,
      name: asset.name,
      iconData: EvaIcons.cube_outline,
    );
  }

  for (var component in components) {
    nodeMap[component.id] = createTreeNode(
      id: component.id,
      name: component.name,
      iconData: AntDesign.codepen_outline,
      trailingIconData: component.status == Status.alert
          ? Icons.circle_rounded
          : FontAwesome.bolt_solid,
      trailingColor:
          component.status == Status.alert ? Colors.red : Colors.green,
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
    if (component.parentId != null && nodeMap.containsKey(component.parentId)) {
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
    leading: const SizedBox(),
  );
}

TreeNode createTreeNode({
  required String id,
  required String name,
  required IconData iconData,
  IconData? trailingIconData,
  Color? trailingColor,
}) {
  return TreeNode(
    id: id,
    name: name,
    children: [],
    leading: Icon(iconData, color: primary),
    trailing: trailingIconData != null
        ? Icon(
            trailingIconData,
            size: Insets.xl,
            color: trailingColor,
          )
        : null,
  );
}
