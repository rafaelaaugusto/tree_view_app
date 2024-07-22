import 'package:fleasy/fleasy.dart';
import 'package:flutter/material.dart';

import '../utils/tree_builder.dart';
import 'node_expansion_tile_component.dart';

class TreeListView extends StatelessWidget {
  const TreeListView({
    super.key,
    required this.root,
  });

  final TreeNode root;

  List<Widget> buildTreeNodes(TreeNode node) {
    List<Widget> children = [];

    for (var child in node.children) {
      children.add(
        NodeExpansionTile(
          title: child.name,
          leading: child.leading,
          hasChildren: child.children.isNotBlank,
          trailing: child.trailing,
          children: buildTreeNodes(child),
        ),
      );
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    final nodes = buildTreeNodes(root);

    return Expanded(
      child: ListView.builder(
        itemCount: nodes.length,
        itemBuilder: (context, index) => nodes[index],
      ),
    );
  }
}
