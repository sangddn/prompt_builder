import 'package:shadcn_ui/shadcn_ui.dart';

String timeAgo(DateTime datetime) {
  final now = DateTime.now();
  final difference = now.difference(datetime);

  if (difference.isNegative) {
    return 'In the future';
  }

  if (difference.inMinutes < 1) {
    return 'Just now';
  }

  if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m ago';
  }

  if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  }

  if (difference.inDays == 1) {
    return 'Yesterday';
  }

  if (difference.inDays < 30) {
    return '${difference.inDays}d ago';
  }

  final formatter = DateFormat('MMM d');
  final yearFormatter = DateFormat('MMM d, y');
  return datetime.year == now.year
      ? formatter.format(datetime)
      : yearFormatter.format(datetime);
}
