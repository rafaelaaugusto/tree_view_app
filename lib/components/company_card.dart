import 'package:fleasy/fleasy.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class CompanyCard extends StatelessWidget {
  const CompanyCard({
    super.key,
    required this.name,
    required this.onPressed,
  });

  final String name;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        name,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      leading: const Icon(FontAwesome.location_pin_solid),
      onTap: onPressed,
      tileColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Insets.m),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: Insets.xl,
        horizontal: Insets.xxl,
      ),
    );
  }
}
