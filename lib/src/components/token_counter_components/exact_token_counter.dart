// ignore_for_file: avoid_redundant_argument_values

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../core/core.dart';
import '../../services/services.dart';
import '../components.dart';

class ExactTokenCounter extends StatefulWidget {
  const ExactTokenCounter({
    this.hasContentChanged,
    required this.getContent,
    super.key,
  });

  final bool Function(BuildContext context, String? currentContent)?
      hasContentChanged;
  final String? Function() getContent;

  @override
  State<ExactTokenCounter> createState() => ExactTokenCounterState();
}

class ExactTokenCounterState extends State<ExactTokenCounter> {
  final _controller = ShadPopoverController();
  Future<Map<LLMProvider, (int, String)?>>? _countFuture;
  String? _content;
  bool _hasContentChanged = false;

  void _count() {
    setState(
      () {
        _content = widget.getContent();
        _hasContentChanged = false;
        final futures = kAllLLMProviders.map((provider) {
          try {
            final r = provider.countTokens(_content!);
            if (r is SynchronousFuture) return Future.value(r);
            return r;
          } on ApiKeyNotSetException {
            return Future.value(null);
          } on HttpException {
            return Future.value(null);
          } catch (e) {
            return Future.value(null);
          }
        });
        _countFuture = Future.wait(futures).then(
          (results) {
            return Map.fromIterables(kAllLLMProviders, results);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    if (!_hasContentChanged) {
      _hasContentChanged = widget.hasContentChanged?.call(context, _content) ??
          _hasContentChanged;
    }
    return AnimatedFutureBuilder(
      future: _countFuture,
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final counts = snapshot.data;
        return ShadPopover(
          controller: _controller,
          popover: (_) =>
              _ExactTokenCounts(counts, isLoading, _hasContentChanged),
          child: MouseRegion(
            onHover: (_) => _controller.show(),
            onExit: (_) => _controller.hide(),
            child: CButton(
              tooltip: null,
              tooltipTriggerMode: TooltipTriggerMode.tap,
              padding: k16H4VPadding,
              onTap: _count,
              child: SizedBox(
                width: double.infinity,
                child: TranslationSwitcher.top(
                  child: Text(
                    counts != null && !_hasContentChanged
                        ? 'Exact Counts'
                        : 'Count Exact',
                    style: theme.textTheme.muted,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    key: ValueKey(counts != null && !_hasContentChanged),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ExactTokenCounts extends StatelessWidget {
  const _ExactTokenCounts(this.counts, this.isLoading, this.hasContentChanged);

  final Map<LLMProvider, (int, String)?>? counts;
  final bool isLoading;
  final bool hasContentChanged;

  @override
  Widget build(BuildContext context) {
    final counts = this.counts;
    if (counts == null || counts.isEmpty || isLoading) {
      return SizedBox(
        width: 200.0,
        height: 48.0,
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator.adaptive()
              : Padding(
                  padding: k8APadding,
                  child: Text(
                    'Count exact tokens with Tiktoken or API.',
                    style: context.textTheme.small,
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
      );
    }
    final textTheme = context.textTheme;
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final MapEntry(key: provider, :value) in counts.entries)
            Row(
              children: [
                Text(value?.$2 ?? provider.name),
                const Spacer(),
                const Gap(8.0),
                if (value != null)
                  Text(
                    '${value.$1}',
                    style: textTheme.list.copyWith(fontWeight: FontWeight.bold),
                  )
                else
                  Text('n/a', style: textTheme.muted),
              ],
            ),
          if (hasContentChanged) ...[
            const Gap(4.0),
            Text(
              'May be outdated. Recount to update.',
              style: textTheme.muted,
            ),
          ],
        ],
      ),
    );
  }
}
