import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TextPromptsPage extends StatelessWidget {
  const TextPromptsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Text Prompts Page')));
  }
}
