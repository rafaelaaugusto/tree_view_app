import 'package:fleasy/fleasy.dart';
import 'package:flutter/material.dart';

import '../theme/colors_theme.dart';

class FilterCard extends StatelessWidget {
  const FilterCard({
    super.key,
    required this.name,
    this.isSelected = false,
    this.leading,
  });

  final String name;
  final bool isSelected;
  final IconData? leading;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Insets.s),
        side: BorderSide(
          color: isSelected ? primary : Colors.black.withOpacity(0.6),
        ),
      ),
      color: isSelected
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onPrimary,
      margin: const EdgeInsets.only(right: Insets.s),
      child: Padding(
        padding: const EdgeInsets.all(Insets.m),
        child: Row(
          children: [
            Icon(
              leading,
              size: Insets.xxl,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Colors.black,
            ),
            const SizedBox(width: Insets.xs),
            Text(
              name,
              style: TextStyle(
                fontSize: Insets.xl,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
