String formatTokenCount(int number) {
  if (number < 1000) return number.toString();
  if (number < 1000000) {
    final k = (number / 1000).toStringAsFixed(1);
    if (k.endsWith('.0')) return '${k.replaceAll('.0', '')}k';
    return '${k}k';
  }
  final m = (number / 1000000).toStringAsFixed(1);
  return '${m}M';
}
