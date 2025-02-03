import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../database/database.dart';

@RoutePage()
class SnippetPage extends StatelessWidget {
  const SnippetPage({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
