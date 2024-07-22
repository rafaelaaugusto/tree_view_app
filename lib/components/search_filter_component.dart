import 'package:fleasy/fleasy.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class SearchFilter extends StatelessWidget {
  const SearchFilter({
    super.key,
    required this.isSelected,
  });

  final List<bool> isSelected;

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
          ToggleButtons(
            isSelected: isSelected,
            renderBorder: false,
            children: [
              FilterOption(
                name: 'Sensor de energia',
                leading: FontAwesome.bolt_solid,
                isSelected: isSelected[0],
              ),
              FilterOption(
                name: 'Sensor de energia',
                leading: FontAwesome.bolt_solid,
                isSelected: isSelected[1],
              )
            ],
          )
        ],
      ),
    );
  }
}

class FilterOption extends StatelessWidget {
  const FilterOption({
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
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(Insets.s),
      ),
      padding: const EdgeInsets.all(Insets.m),
      margin: const EdgeInsets.only(right: Insets.s),
      child: Row(
        children: [
          Icon(
            leading,
            size: Insets.xxl,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
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
    );
  }
}
