part of 'prompt_block_card.dart';

class _BlockContentRouter extends StatelessWidget {
  const _BlockContentRouter();

  @override
  Widget build(BuildContext context) =>
      switch (context.selectBlock((b) => b.type)) {
        BlockType.text => const _TextBlock(),
        BlockType.image => const _ImageBlock(),
        BlockType.audio ||
        BlockType.video ||
        BlockType.youtube =>
          const _AudioVideoBlock(),
        BlockType.localFile => const _LocalFileBlock(),
        BlockType.webUrl => const _WebBlock(),
        BlockType.unsupported => const _UnsupportedBlock(),
      };
}
