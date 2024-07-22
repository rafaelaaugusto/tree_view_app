import 'package:flutter/material.dart';

import '../components/search_filter_component.dart';
import '../components/tree_list_view_component.dart';
import '../pages/asset_page.dart';

class AssetView extends StatelessWidget {
  const AssetView({
    super.key,
    required this.root,
  });

  final TreeNode root;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SearchFilter(),
        TreeListView(root: root),
      ],
    );
  }
}
