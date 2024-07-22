import 'package:fleasy/fleasy.dart';
import 'package:flutter/material.dart';

import '../pages/asset_page.dart';
import 'node_expansion_tile_component.dart';

class TreeListView extends StatelessWidget {
  const TreeListView({
    super.key,
    required this.root,
  });

  final TreeNode root;

  List<Widget> buildTree(TreeNode node) {
    List<Widget> children = [];

    for (var child in node.children) {
      children.add(
        NodeExpansionTile(
          title: child.name,
          leading: child.leading,
          hasChildren: child.children.isNotBlank,
          trailing: child.trailing,
          children: buildTree(child),
        ),
      );
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    final nodes = buildTree(root);

    return Expanded(
      child: ListView.builder(
        itemCount: nodes.length,
        itemBuilder: (context, index) => nodes[index],
      ),
    );
  }
}
