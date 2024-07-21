import 'package:fleasy/fleasy.dart';
import 'package:flutter/material.dart';

import '../pages/asset_page.dart';

class Tree extends StatelessWidget {
  const Tree({
    super.key,
    required this.root,
  });

  final TreeNode root;

  List<Widget> buildTree(TreeNode node) {
    List<Widget> children = [];

    for (var child in node.children) {
      children.add(
        ExpansionTile(
          childrenPadding: const EdgeInsets.only(left: Insets.m),
          title: Text(child.name),
          leading: child.leading,
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
    return ListView.builder(
      itemCount: nodes.length,
      itemBuilder: (context, index) => nodes[index],
    );
  }
}
