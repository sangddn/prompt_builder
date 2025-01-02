part of '../prompt_page.dart';

class _PPMainBody extends StatelessWidget {
  const _PPMainBody();

  @override
  Widget build(BuildContext context) {
    return const ShadResizablePanelGroup(
      resetOnDoubleTap: true,
      dividerColor: Colors.transparent,
      dividerSize: 16.0,
      children: [
        ShadResizablePanel(
          defaultSize: .2,
          minSize: .125,
          maxSize: .3,
          child: _PPFolderTree(),
        ),
        ShadResizablePanel(
          defaultSize: .6,
          minSize: .4,
          maxSize: .75,
          child: _PPPromptContent(),
        ),
        ShadResizablePanel(
          defaultSize: .2,
          minSize: .125,
          maxSize: .3,
          child: _PPRightSidebar(),
        ),
      ],
    );
  }
}
