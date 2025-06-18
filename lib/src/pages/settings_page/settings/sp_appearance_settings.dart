part of '../settings_page.dart';

class AppearanceSettings extends StatefulWidget {
  const AppearanceSettings({super.key});

  @override
  State<AppearanceSettings> createState() => _AppearanceSettingsState();
}

class _AppearanceSettingsState extends State<AppearanceSettings> {
  final _themeModeStream = streamThemeMode();
  final _themeAccentStream = streamThemeAccent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StreamBuilder(
          initialData: kInitialThemeMode,
          stream: _themeModeStream,
          builder: (context, snapshot) {
            final themeMode = snapshot.data ?? kInitialThemeMode;
            return CupertinoSlidingSegmentedControl(
              onValueChanged: (value) {
                if (value != themeMode && value != null) {
                  setThemeMode(value);
                }
              },
              groupValue: themeMode,
              children: const {
                ThemeMode.system: _AppearanceItem(
                  'System',
                  HugeIcons.strokeRoundedComputer,
                ),
                ThemeMode.light: _AppearanceItem(
                  'Light',
                  HugeIcons.strokeRoundedSun03,
                ),
                ThemeMode.dark: _AppearanceItem(
                  'Dark',
                  HugeIcons.strokeRoundedMoon02,
                ),
              },
            );
          },
        ),
        const Gap(16.0),
        StreamBuilder(
          initialData: kInitialThemeAccent,
          stream: _themeAccentStream,
          builder: (context, snapshot) {
            final themeAccent = snapshot.data ?? kInitialThemeAccent;
            return Container(
              height: 54.0,
              decoration: ShapeDecoration(
                shape: Superellipse.border12,
                color: PColors.lightGray.resolveFrom(context),
              ),
              padding: k16H8VPadding,
              alignment: Alignment.center,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                clipBehavior: Clip.none,
                itemCount: ThemeAccent.values.length,
                itemBuilder:
                    (context, index) => _ThemeAccentItem(
                      ThemeAccent.values[index],
                      ThemeAccent.values[index] == themeAccent,
                      () => setThemeAccent(ThemeAccent.values[index]),
                    ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _AppearanceItem extends StatelessWidget {
  const _AppearanceItem(this.label, this.icon);

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Padding(
    padding: k12VPadding,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 16.0), const Gap(4.0), Text(label)],
    ),
  );
}

class _ThemeAccentItem extends StatelessWidget {
  const _ThemeAccentItem(this.accent, this.isSelected, this.onTap);

  final ThemeAccent accent;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = accent.representativeColor.resolveFrom(context);
    final selectedBorderColor = color.replaceOpacity(0.7);

    final colorCircle = AnimatedContainer(
      duration: Effects.shortDuration,
      curve: Effects.swiftOutCurve,
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border:
            isSelected
                ? Border.all(color: selectedBorderColor, width: 2.0)
                : null,
      ),
      width: 32.0,
      height: 32.0,
      child: DecoratedBox(
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );

    return CButton(
      tooltip: accent.name.capitalize(),
      onTap: onTap,
      padding: const EdgeInsets.all(3.0),
      child: EnlargeOnHover(scale: 1.05, child: colorCircle),
    );
  }
}
