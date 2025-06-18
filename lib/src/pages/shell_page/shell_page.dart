import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../core/core.dart';
import '../../database/database.dart';
import '../../router/router.dart';
import '../../router/router.gr.dart';
import '../library_page/library_observer.dart';

@RoutePage()
class AppShellPage extends StatefulWidget {
  const AppShellPage({super.key});

  @override
  State<AppShellPage> createState() => _AppShellPageState();
}

class _AppShellPageState extends State<AppShellPage> {
  TabsRouter? _tabsRouter;
  // ignore: avoid_setters_without_getters
  set tabsRouter(TabsRouter value) {
    _tabsRouter = value;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableProvider<TabsRouter?>.value(
      value: _tabsRouter,
      child: const Scaffold(
        body: Row(children: [_Sidebar(), Expanded(child: AutoRouter())]),
      ),
    );
  }
}

@RoutePage()
class MainTabsPage extends StatelessWidget {
  const MainTabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var lastIndex = 0;
    return AutoTabsRouter(
      homeIndex: 0,
      routes: const [
        LibraryRoute(),
        ProjectsRoute(),
        SnippetsRoute(),
        SettingsRoute(),
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
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );

        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: SlideTransition(position: position, child: child),
        );
      },
      builder: (context, child) {
        final noTabsRouter = context.select(
          (TabsRouter? tabsRouter) => tabsRouter == null,
        );
        if (noTabsRouter) {
          context
              .findAncestorStateOfType<_AppShellPageState>()!
              .tabsRouter = AutoTabsRouter.of(context, watch: true);
        }
        return CallbackShortcuts(
          bindings: {
            const SingleActivator(meta: true, LogicalKeyboardKey.keyN):
                () => _openNewPrompt(context),
          },
          child: child,
        );
      },
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
          _NavButton(HugeIcons.strokeRoundedFolder01, 'Projects', 1),
          _NavButton(HugeIcons.strokeRoundedQuoteDown, 'Snippets', 2),
          _NavButton(HugeIcons.strokeRoundedSettings01, 'Settings', 3),
          _NavButton(CupertinoIcons.question_circle, 'Resources', 4),
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
    final tabsRouter = context.watch<TabsRouter?>();
    final isActive = tabsRouter?.activeIndex == index;
    return CButton(
      tooltip: tooltip,
      padding: k24H12VPadding,
      cornerRadius: 16.0,
      color: isActive ? PColors.lightGray.resolveFrom(context) : null,
      child: EnlargeOnHover(
        child: Icon(
          icon,
          size: 24.0,
          color:
              isActive
                  ? context.colorScheme.foreground
                  : PColors.darkGray.resolveFrom(context),
        ),
      ),
      onTap: () {
        tabsRouter?.setActiveIndex(index);
        final active = tabsRouter?.current;
        if (context.router.topRoute.name != active?.name) {
          context.router.popUntil(scoped: false, (route) {
            return route.data?.name == 'MainTabsRoute';
          });
        }
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
  final id = await context.read<Database>().createPrompt();
  if (!context.mounted) return;
  NewPromptAddedNotification(id: id).dispatch(context);
  context.pushPromptRoute(id: id);
}
