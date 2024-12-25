import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class PromptPage extends StatelessWidget {
  const PromptPage({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Prompt Page'),
      ),
    );
  }
}
