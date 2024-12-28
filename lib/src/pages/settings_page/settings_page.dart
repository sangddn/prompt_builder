import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../../components/components.dart';
import '../../core/core.dart';
import '../../services/services.dart';

part 'settings/sp_appearance_settings.dart';
part 'settings/sp_llm_providers.dart';
part 'settings/sp_llm_preferences.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedCustomScrollView(
        slivers: [
          const PAppBar(title: Text('Settings')),
          const SliverGap(8.0),
          SliverPadding(
            padding: k16HPadding,
            sliver: SuperSliverList.list(
              children: const [
                AppearanceSettings(),
                Gap(16.0),
                Divider(thickness: .5, height: .5, indent: 16, endIndent: 16),
                Gap(16.0),
                LLMProviderSettings(),
                Gap(16.0),
                LLMPreferencesSettings(),
              ],
            ),
          ),
          const SliverGap(128.0),
        ],
      ),
    );
  }
}
