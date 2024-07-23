import 'package:fleasy/fleasy.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import 'filter_card_component.dart';

class SearchFilter extends StatelessWidget {
  const SearchFilter({
    super.key,
    required this.isSelected,
    required this.selectFilter,
    required this.resetFilter,
  });

  final List<bool> isSelected;
  final Function(int) selectFilter;
  final Function() resetFilter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Insets.l * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextField(
            decoration: InputDecoration(
              hintText: 'Buscar Ativo ou Local',
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Color(0XFFEAEFF3),
              contentPadding: EdgeInsets.all(Insets.l),
              border: InputBorder.none,
            ),
          ),
          Row(
            children: [
              ToggleButtons(
                fillColor: Colors.white,
                splashColor: Colors.white,
                onPressed: selectFilter,
                isSelected: isSelected,
                renderBorder: false,
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
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
