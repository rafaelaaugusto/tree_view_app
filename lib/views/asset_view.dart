import 'package:flutter/material.dart';

import '../components/search_filter_component.dart';
import '../components/tree_list_view_component.dart';
import '../utils/tree_builder.dart';

class AssetView extends StatelessWidget {
  const AssetView({
    super.key,
    required this.root,
    required this.filterSelected,
    required this.selectFilter,
  });

  final TreeNode root;
  final List<bool> filterSelected;
  final Function(int) selectFilter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchFilter(
          isSelected: filterSelected,
          selectFilter: selectFilter,
        ),
        const Divider(),
        TreeListView(root: root),
      ],
    );
  }
}
