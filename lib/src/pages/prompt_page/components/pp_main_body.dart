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
          child: Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: ShadResizablePanelGroup(
              axis: Axis.vertical,
              dividerThickness: 0.75,
              dividerSize: 16.0,
              resetOnDoubleTap: true,
              children: [
                ShadResizablePanel(
                  defaultSize: .4,
                  minSize: .1,
                  maxSize: .9,
                  child: _PPSearchSection(),
                ),
                ShadResizablePanel(
                  defaultSize: .6,
                  minSize: .1,
                  maxSize: .9,
                  child: _PPFolderTree(),
                ),
              ],
            ),
          ),
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
