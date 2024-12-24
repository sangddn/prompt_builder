import 'package:flutter/material.dart';

import '../components.dart';

class PInk extends StatelessWidget {
  const PInk({
    this.cornerRadius = 12.0,
    required this.enabled,
    required this.child,
    super.key,
  });

  final double cornerRadius;
  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: Superellipse(cornerRadius: cornerRadius),
      clipBehavior: Clip.antiAlias,
      child: InkResponse(
        onTap: enabled ? () {} : null,
        highlightShape: BoxShape.rectangle,
        child: child,
      ),
    );
  }
}
