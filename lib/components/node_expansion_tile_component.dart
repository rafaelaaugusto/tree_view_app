import 'package:fleasy/fleasy.dart';
import 'package:flutter/material.dart';

class NodeExpansionTile extends StatelessWidget {
  const NodeExpansionTile({
    super.key,
    required this.title,
    required this.children,
    required this.hasChildren,
    this.leading,
    this.trailing,
  });

  final String title;
  final List<Widget> children;
  final bool hasChildren;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      dense: true,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasChildren)
            const Icon(
              Icons.keyboard_arrow_down_rounded,
            ),
          leading ?? const SizedBox(),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Insets.s),
              child: Text(
                title,
                style: const TextStyle(fontSize: Insets.xl),
              ),
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
