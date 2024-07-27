import 'package:fleasy/fleasy.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../theme/colors_theme.dart';
import 'filter_card_component.dart';

class SearchFilter extends StatelessWidget {
  const SearchFilter({
    super.key,
    required this.isSelected,
    required this.selectFilter,
    required this.filterText,
    required this.resetFilter,
    required this.resultCount,
  });

  final List<bool> isSelected;
  final Function(int) selectFilter;
  final Function(String) filterText;
  final Function() resetFilter;
  final int resultCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Insets.l * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: filterText,
            decoration: const InputDecoration(
              hintText: 'Buscar Ativo ou Local',
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: inputColor,
              contentPadding: EdgeInsets.all(Insets.l),
              border: InputBorder.none,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ToggleButtons(
                onPressed: selectFilter,
                isSelected: isSelected,
                renderBorder: false,
                fillColor: Theme.of(context).colorScheme.onPrimary,
                splashColor: Theme.of(context).colorScheme.onPrimary,
                children: [
                  FilterCard(
                    name: 'Sensor de energia',
                    leading: FontAwesome.bolt_solid,
                    isSelected: isSelected[0],
                  ),
                  FilterCard(
                    name: 'Crítico',
                    leading: Icons.info_outline,
                    isSelected: isSelected[1],
                  ),
                ],
              ),
              if (isSelected.contains(true))
                IconButton(
                  onPressed: resetFilter,
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
            ],
          ),
          if (isSelected[0] == true)
            Text('$resultCount sensores de energia encontrados.'),
          if (isSelected[1] == true)
            Text('$resultCount ativos com estado crítico encontrados.'),
        ],
      ),
    );
  }
}
