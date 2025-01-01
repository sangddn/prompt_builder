part of 'block_content_viewer.dart';

class _BCVImageViewer extends StatelessWidget {
  const _BCVImageViewer({required this.provider});

  final ImageProvider provider;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image(
        image: provider,
        errorBuilder: (context, error, stackTrace) =>
            const Center(child: Text('Error loading image')),
      ),
    );
  }
}
