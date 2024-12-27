part of 'local_file_viewer.dart';

class _ImageViewer extends StatelessWidget {
  const _ImageViewer({required this.filePath});
  final String filePath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.file(
        File(filePath),
        errorBuilder: (context, error, stackTrace) =>
            const Center(child: Text('Error loading image')),
      ),
    );
  }
}
