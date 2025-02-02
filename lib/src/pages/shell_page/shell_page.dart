import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/components.dart';
import '../../core/core.dart';
import '../../database/database.dart';
import '../../router/router.gr.dart';
import '../library_page/library_observer.dart';

@RoutePage()
class ShellPage extends StatelessWidget {
  const ShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    var lastIndex = 0;
    return AutoTabsRouter(
      homeIndex: 0,
      routes: [
        LibraryRoute(),
        SnippetsRoute(),
        const SettingsRoute(),
        ResourcesRoute(),
      ],
      transitionBuilder: (context, child, animation) {
        final newIndex = AutoTabsRouter.of(context).activeIndex;
        if (animation.isCompleted || animation.isDismissed) {
          lastIndex = newIndex;
        }
        final position = Tween<Offset>(
          begin: Offset(0.0, lastIndex < newIndex ? 0.05 : -0.05),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
        );

        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: SlideTransition(
            position: position,
            child: child,
          ),
        );
      },
      builder: (context, child) => CallbackShortcuts(
        bindings: {
          const SingleActivator(meta: true, LogicalKeyboardKey.keyN): () =>
              _openNewPrompt(context),
        },
        child: Scaffold(
          body: Row(
            children: [
              const _Sidebar(),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsetsDirectional.only(start: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8.0,
        children: [
          _NewPromptButton(),
          _NavButton(HugeIcons.strokeRoundedHome09, 'Library', 0),
          _NavButton(HugeIcons.strokeRoundedQuoteDown, 'Snippets', 1),
          _NavButton(HugeIcons.strokeRoundedSettings01, 'Settings', 2),
          _NavButton(CupertinoIcons.question_circle, 'Resources', 3),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton(this.icon, this.tooltip, this.index);

  final IconData icon;
  final String tooltip;
  final int index;

  @override
  Widget build(BuildContext context) {
    final tabsRouter = AutoTabsRouter.of(context, watch: true);
    final isActive = tabsRouter.activeIndex == index;
    return CButton(
      tooltip: tooltip,
      padding: k24H12VPadding,
      cornerRadius: 16.0,
      color: isActive ? PColors.lightGray.resolveFrom(context) : null,
      child: EnlargeOnHover(
        child: Icon(
          icon,
          size: 24.0,
          color: isActive
              ? context.colorScheme.foreground
              : PColors.darkGray.resolveFrom(context),
        ),
      ),
      onTap: () {
        tabsRouter.setActiveIndex(index);
      },
    );
  }
}

class _NewPromptButton extends StatelessWidget {
  const _NewPromptButton();

  @override
  Widget build(BuildContext context) {
    return CButton(
      tooltip: 'New Prompt',
      onTap: () => _openNewPrompt(context),
      color: PColors.gray.resolveFrom(context),
      padding: k24H12VPadding,
      cornerRadius: 16.0,
      child: EnlargeOnHover(
        child: Icon(
          CupertinoIcons.plus,
          size: 24.0,
          color: PColors.textGray.resolveFrom(context),
        ),
      ),
    );
  }
}

Future<void> _openNewPrompt(BuildContext context) async {
  final id = await Database().createPrompt();
  if (!context.mounted) return;
  NewPromptAddedNotification(id: id).dispatch(context);
  context.router.popAndPush(PromptRoute(id: id));
}
