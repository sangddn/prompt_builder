// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../core.dart';

extension SafeSetState on State {
  void maybeSetState([VoidCallback? fn]) {
    if (mounted) {
      setState(fn ?? () {});
    }
  }

  void verySafeSetState([VoidCallback? fn]) {
    if (mounted) {
      scheduleMicrotask(() {
        setState(fn ?? () {});
      });
    }
  }
}

/// A widget that rebuilds itself when the value of [valueListenable] changes
/// based on the value returned by [selector].
///
/// This is an analog of [ValueListenableBuilder] but instead of rebuilding
/// itself when the value of [valueListenable] changes, it rebuilds itself
/// when the value of [valueListenable] changes to a value that you care about.
///
class SelectValueBuilder<T, R> extends StatefulWidget {
  const SelectValueBuilder({
    required this.valueListenable,
    required this.selector,
    required this.builder,
    super.key,
  });

  /// The [ValueListenable] whose value we want to listen to.
  ///
  final ValueListenable<T> valueListenable;

  /// A function that returns the value of [valueListenable] that we care about.
  ///
  final R Function(T value) selector;

  /// A function that builds the widget based on the value returned by
  /// [selector].
  ///
  final Widget Function(BuildContext context, R value) builder;

  @override
  State<SelectValueBuilder<T, R>> createState() => _SelectValueBuilderState();
}

class _SelectValueBuilderState<T, R> extends State<SelectValueBuilder<T, R>> {
  late R _value = widget.selector(widget.valueListenable.value);

  @override
  void initState() {
    super.initState();
    widget.valueListenable.addListener(_onValueChanged);
  }

  @override
  void didUpdateWidget(covariant SelectValueBuilder<T, R> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.valueListenable != widget.valueListenable) {
      oldWidget.valueListenable.removeListener(_onValueChanged);
      widget.valueListenable.addListener(_onValueChanged);
    }
  }

  void _onValueChanged() {
    final newValue = widget.selector(widget.valueListenable.value);
    if (newValue != _value) {
      setState(() {
        _value = newValue;
      });
    }
  }

  @override
  void dispose() {
    widget.valueListenable.removeListener(_onValueChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _value);
  }
}

class CombinedValueBuilder2<V1, V2, T, R> extends StatefulWidget {
  const CombinedValueBuilder2({
    required this.v1,
    required this.v2,
    required this.combine,
    required this.builder,
    super.key,
  });

  final ValueListenable<V1> v1;
  final ValueListenable<V2> v2;
  final (T, R) Function(V1 value1, V2 value2) combine;
  final Widget Function(BuildContext context, T value1, R value2) builder;

  @override
  State<CombinedValueBuilder2<V1, V2, T, R>> createState() =>
      _CombinedValueBuilder2State();
}

class _CombinedValueBuilder2State<V1, V2, T, R>
    extends State<CombinedValueBuilder2<V1, V2, T, R>> {
  late (T, R) _vals = widget.combine(widget.v1.value, widget.v2.value);

  @override
  void initState() {
    super.initState();
    widget.v1.addListener(_onValueChanged);
    widget.v2.addListener(_onValueChanged);
  }

  @override
  void didUpdateWidget(
    covariant CombinedValueBuilder2<V1, V2, T, R> oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.v1 != widget.v1) {
      oldWidget.v1.removeListener(_onValueChanged);
      widget.v1.addListener(_onValueChanged);
    }
    if (oldWidget.v2 != widget.v2) {
      oldWidget.v2.removeListener(_onValueChanged);
      widget.v2.addListener(_onValueChanged);
    }
  }

  void _onValueChanged() {
    final newVals = widget.combine(widget.v1.value, widget.v2.value);
    if (newVals != _vals) {
      setState(() {
        _vals = newVals;
      });
    }
  }

  @override
  void dispose() {
    widget.v1.removeListener(_onValueChanged);
    widget.v2.removeListener(_onValueChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _vals.$1, _vals.$2);
  }
}

class CombinedValueBuilder3<V1, V2, V3, T, R, P> extends StatefulWidget {
  const CombinedValueBuilder3({
    required this.v1,
    required this.v2,
    required this.v3,
    required this.combine,
    required this.builder,
    super.key,
  });

  final ValueListenable<V1> v1;
  final ValueListenable<V2> v2;
  final ValueListenable<V3> v3;
  final (T, R, P) Function(V1 value1, V2 value2, V3 value3) combine;
  final Widget Function(BuildContext context, T value1, R value2, P value3)
      builder;

  @override
  State<CombinedValueBuilder3<V1, V2, V3, T, R, P>> createState() =>
      _CombinedValueBuilder3State();
}

class _CombinedValueBuilder3State<V1, V2, V3, T, R, P>
    extends State<CombinedValueBuilder3<V1, V2, V3, T, R, P>> {
  late (T, R, P) _vals =
      widget.combine(widget.v1.value, widget.v2.value, widget.v3.value);

  @override
  void initState() {
    super.initState();
    widget.v1.addListener(_onValueChanged);
    widget.v2.addListener(_onValueChanged);
    widget.v3.addListener(_onValueChanged);
  }

  @override
  void didUpdateWidget(
    covariant CombinedValueBuilder3<V1, V2, V3, T, R, P> oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.v1 != widget.v1) {
      oldWidget.v1.removeListener(_onValueChanged);
      widget.v1.addListener(_onValueChanged);
    }
    if (oldWidget.v2 != widget.v2) {
      oldWidget.v2.removeListener(_onValueChanged);
      widget.v2.addListener(_onValueChanged);
    }
    if (oldWidget.v3 != widget.v3) {
      oldWidget.v3.removeListener(_onValueChanged);
      widget.v3.addListener(_onValueChanged);
    }
  }

  void _onValueChanged() {
    final newVals =
        widget.combine(widget.v1.value, widget.v2.value, widget.v3.value);
    if (newVals != _vals) {
      setState(() {
        _vals = newVals;
      });
    }
  }

  @override
  void dispose() {
    widget.v1.removeListener(_onValueChanged);
    widget.v2.removeListener(_onValueChanged);
    widget.v3.removeListener(_onValueChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _vals.$1, _vals.$2, _vals.$3);
  }
}

class ValueBuilder<T> extends StatelessWidget {
  const ValueBuilder({
    required this.v1,
    required this.builder,
    this.child,
    super.key,
  });

  final ValueListenable<T> v1;
  final Widget Function(BuildContext context, T value1, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([v1]),
      builder: (context, child) => builder(context, v1.value, child),
      child: child,
    );
  }
}

class ValueBuilder2<T, R> extends StatelessWidget {
  const ValueBuilder2({
    required this.v1,
    required this.v2,
    required this.builder,
    this.child,
    super.key,
  });

  final ValueListenable<T> v1;
  final ValueListenable<R> v2;
  final Widget Function(BuildContext context, T value1, R value2, Widget? child)
      builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([v1, v2]),
      builder: (context, child) => builder(context, v1.value, v2.value, child),
      child: child,
    );
  }
}

class ValueBuilder3<T, R, P> extends StatelessWidget {
  const ValueBuilder3({
    required this.v1,
    required this.v2,
    required this.v3,
    required this.builder,
    this.child,
    super.key,
  });

  final ValueListenable<T> v1;
  final ValueListenable<R> v2;
  final ValueListenable<P> v3;
  final Widget Function(
    BuildContext context,
    T value1,
    R value2,
    P value3,
    Widget? child,
  ) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([v1, v2, v3]),
      builder: (context, child) =>
          builder(context, v1.value, v2.value, v3.value, child),
      child: child,
    );
  }
}

class ValueBuilder4<T, R, P, Q> extends StatelessWidget {
  const ValueBuilder4({
    required this.v1,
    required this.v2,
    required this.v3,
    required this.v4,
    required this.builder,
    this.child,
    super.key,
  });

  final ValueListenable<T> v1;
  final ValueListenable<R> v2;
  final ValueListenable<P> v3;
  final ValueListenable<Q> v4;
  final Widget Function(
    BuildContext context,
    T value1,
    R value2,
    P value3,
    Q value4,
    Widget? child,
  ) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([v1, v2, v3, v4]),
      builder: (context, child) =>
          builder(context, v1.value, v2.value, v3.value, v4.value, child),
      child: child,
    );
  }
}

class FutureBuilder2<T, R> extends StatefulWidget {
  const FutureBuilder2({
    this.initialData1,
    this.initialData2,
    required this.future1,
    required this.future2,
    required this.builder,
    super.key,
  });

  final T? initialData1;
  final R? initialData2;
  final Future<T>? future1;
  final Future<R>? future2;
  final Widget Function(
    BuildContext context,
    AsyncSnapshot<T> snapshot1,
    AsyncSnapshot<R> snapshot2,
  ) builder;

  @override
  State<FutureBuilder2<T, R>> createState() => _FutureBuilder2State<T, R>();
}

class _FutureBuilder2State<T, R> extends State<FutureBuilder2<T, R>> {
  late final _future1 = widget.future1;
  late final _future2 = widget.future2;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      initialData: widget.initialData1,
      future: _future1,
      builder: (context, snapshot1) {
        return FutureBuilder<R>(
          initialData: widget.initialData2,
          future: _future2,
          builder: (context, snapshot2) {
            return widget.builder(context, snapshot1, snapshot2);
          },
        );
      },
    );
  }
}

class FutureBuilder3<T, R, P> extends StatefulWidget {
  const FutureBuilder3({
    required this.future1,
    required this.future2,
    required this.future3,
    required this.builder,
    super.key,
  });

  final Future<T> future1;
  final Future<R> future2;
  final Future<P> future3;
  final Widget Function(
    BuildContext context,
    AsyncSnapshot<T> snapshot1,
    AsyncSnapshot<R> snapshot2,
    AsyncSnapshot<P> snapshot3,
  ) builder;

  @override
  State<FutureBuilder3<T, R, P>> createState() =>
      _FutureBuilder3State<T, R, P>();
}

class _FutureBuilder3State<T, R, P> extends State<FutureBuilder3<T, R, P>> {
  late final _future1 = widget.future1;
  late final _future2 = widget.future2;
  late final _future3 = widget.future3;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _future1,
      builder: (context, snapshot1) {
        return FutureBuilder<R>(
          future: _future2,
          builder: (context, snapshot2) {
            return FutureBuilder<P>(
              future: _future3,
              builder: (context, snapshot3) {
                return widget.builder(context, snapshot1, snapshot2, snapshot3);
              },
            );
          },
        );
      },
    );
  }
}

class StreamBuilder2<T, R> extends StatelessWidget {
  const StreamBuilder2({
    this.initialValue1,
    this.initialValue2,
    required this.stream1,
    required this.stream2,
    required this.builder,
    super.key,
  });

  final T? initialValue1;
  final R? initialValue2;
  final Stream<T> stream1;
  final Stream<R> stream2;
  final Widget Function(
    BuildContext context,
    AsyncSnapshot<T> snapshot1,
    AsyncSnapshot<R> snapshot2,
  ) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: initialValue1,
      stream: stream1,
      builder: (context, snapshot1) {
        return StreamBuilder<R>(
          initialData: initialValue2,
          stream: stream2,
          builder: (context, snapshot2) {
            return builder(context, snapshot1, snapshot2);
          },
        );
      },
    );
  }
}

class SelectListenableBuilder<T extends Listenable?, R> extends StatefulWidget {
  const SelectListenableBuilder({
    required this.listenable,
    required this.selector,
    required this.builder,
    this.child,
    super.key,
  });

  final T listenable;
  final R Function(T listenable) selector;
  final Widget Function(BuildContext context, R value, Widget? child) builder;
  final Widget? child;

  @override
  State<SelectListenableBuilder<T, R>> createState() =>
      _SelectListenableBuilderState<T, R>();
}

class _SelectListenableBuilderState<T extends Listenable?, R>
    extends State<SelectListenableBuilder<T, R>> {
  late var _value = widget.selector.call(widget.listenable);

  void _handleChange() {
    final newValue = widget.selector.call(widget.listenable);
    if (newValue != _value) {
      setState(() {
        _value = newValue;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.listenable?.addListener(_handleChange);
  }

  @override
  void didUpdateWidget(SelectListenableBuilder<T, R> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.listenable != oldWidget.listenable) {
      oldWidget.listenable?.removeListener(_handleChange);
      widget.listenable?.addListener(_handleChange);
    }
  }

  @override
  void dispose() {
    widget.listenable?.removeListener(_handleChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, _value, widget.child);
}

abstract class MultiProviderWidget extends StatelessWidget {
  const MultiProviderWidget({super.key});

  List<SingleChildWidget> get providers;

  Widget buildChild(BuildContext context);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: providers,
        builder: (context, _) => buildChild(context),
      );
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

typedef TextEditingProvider = ChangeNotifierProvider<TextEditingController>;

/// {@template state_provider}
/// A [Provider] that provides a [ValueNotifier] of a type T and the contained
/// value via a [ProxyProvider].
///
/// Example:
/// ```dart
/// StateProvider<String>(
///   createInitialValue: (_) => 'initial value',
///   builder: (context, _) {
///       // Access the ValueNotifier
///       final notifier = context.read<ValueNotifier<String>>();
///       // Access the value directly
///       final value = context.read<String>();
///       return Text(value);
///   },
/// )
/// ```
///
/// ! This cannot be used inside a [MultiProvider] as [MultiProvider] ignores
/// children of its providers.
/// {@endtemplate}
///
class StateProvider<T> extends ChangeNotifierProvider<ValueNotifier<T>> {
  /// {@macro state_provider}
  StateProvider({
    required T Function(BuildContext context) createInitialValue,
    void Function(BuildContext context, ValueNotifier<T> notifier)? initState,
    void Function(BuildContext context, T value)? onValueChanged,
    UpdateShouldNotify<T>? updateShouldNotify,
    Dispose<T>? dispose,
    TransitionBuilder? builder,
    Widget Function(BuildContext context, T value, Widget? child)? valueBuilder,
    super.lazy,
    Widget? child,
    super.key,
  })  : assert(
          valueBuilder == null || builder == null,
          'Cannot use both valueBuilder and builder',
        ),
        super(
          create: (context) {
            final notifier = ValueNotifier(createInitialValue(context));
            initState?.call(context, notifier);
            if (onValueChanged != null) {
              notifier
                  .addListener(() => onValueChanged(context, notifier.value));
            }
            return notifier;
          },
          child: ProxyProvider<ValueNotifier<T>, T>(
            update: (context, notifier, previous) => notifier.value,
            updateShouldNotify: updateShouldNotify,
            dispose: dispose,
            builder: builder ??
                valueBuilder
                    ?.let((b) => (c, child) => b(c, c.watch<T>(), child)),
            child: child,
          ),
        );
}

/// A [ChangeNotifierProvider] that provides a callback for dispose before
/// disposing the notifier.
///
/// This is useful for side effects just before the provider and notifier is
/// disposed.
class ValueProvider<T extends ChangeNotifier> extends ListenableProvider<T> {
  ValueProvider({
    required T Function(BuildContext context) create,
    void Function(BuildContext context, T? notifier)? onNotified,
    void Function(BuildContext context, T? notifier)? onDisposed,
    super.lazy,
    super.builder,
    super.child,
    super.key,
  }) : super(
          create: (context) {
            final notifier = create(context);
            if (onNotified != null) {
              notifier.addListener(() => onNotified(context, notifier));
            }
            return notifier;
          },
          dispose: (BuildContext context, T? notifier) {
            onDisposed?.call(context, notifier);
            notifier?.dispose();
          },
        );
}
