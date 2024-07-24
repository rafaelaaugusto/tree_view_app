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
    required this.filterText,
    required this.resetFilter,
  });

  final TreeNode root;
  final List<bool> filterSelected;
  final Function(int) selectFilter;
  final Function(String) filterText;
  final Function() resetFilter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchFilter(
          filterText: filterText,
          isSelected: filterSelected,
          selectFilter: selectFilter,
          resetFilter: resetFilter,
        ),
        const Divider(),
        TreeListView(root: root),
      ],
    );
  }
}
