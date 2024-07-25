import 'package:fleasy/fleasy.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: Insets.l,
          ),
          Text('Por favor, aguarde...'),
        ],
      ),
    );
  }
}
