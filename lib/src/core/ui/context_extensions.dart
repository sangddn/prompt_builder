part of 'ui.dart';

extension ContextX on BuildContext {
  bool get ltr => Directionality.of(this) == TextDirection.ltr;
  bool get rtl => Directionality.of(this) == TextDirection.rtl;
}
