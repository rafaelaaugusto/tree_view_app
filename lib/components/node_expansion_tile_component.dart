import 'package:fleasy/fleasy.dart';
import 'package:flutter/material.dart';

class NodeExpansionTile extends StatelessWidget {
  const NodeExpansionTile({
    super.key,
    required this.title,
    required this.leading,
    required this.children,
    required this.hasChildren,
    this.trailing,
  });

  final String title;
  final Widget leading;
  final List<Widget> children;
  final bool hasChildren;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Row(
        children: [
          if (hasChildren) ...[
            const Icon(
              Icons.keyboard_arrow_down_rounded,
            ),
            const SizedBox(width: Insets.s),
          ],
          leading,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Insets.s),
            child: Text(
              title,
              style: const TextStyle(fontSize: Insets.xl),
            ),
          ),
          trailing ?? const SizedBox(),
        ],
      ),
      trailing: const SizedBox(),
      shape: const RoundedRectangleBorder(),
      childrenPadding: const EdgeInsets.only(left: Insets.l * 2),
      children: children,
    );
  }
}
