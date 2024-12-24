import 'package:flutter/material.dart';

class InvertedColor extends StatefulWidget {
  const InvertedColor({
    this.shouldInvert = true,
    required this.child,
    super.key,
  });

  final bool shouldInvert;
  final Widget child;

  @override
  State<InvertedColor> createState() => _InvertedColorState();
}

class _InvertedColorState extends State<InvertedColor> {
  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (!widget.shouldInvert) {
      return KeyedSubtree(
        key: _key,
        child: widget.child,
      );
    }

    return ColorFiltered(
      key: _key,
      // invert color to make it white
      colorFilter: const ColorFilter.matrix(<double>[
        -1,
        0,
        0,
        0,
        255,
        0,
        -1,
        0,
        0,
        255,
        0,
        0,
        -1,
        0,
        255,
        0,
        0,
        0,
        1,
        0,
      ]),
      child: widget.child,
    );
  }
}
