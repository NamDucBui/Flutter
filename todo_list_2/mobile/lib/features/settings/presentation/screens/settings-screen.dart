import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings-provider.dart';

/// App settings screen: theme toggle, notes sort order, app info.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(appThemeModeProvider);
    final sortAsync = ref.watch(notesSortPreferenceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Appearance'),
          themeModeAsync.when(
            loading: () => const ListTile(title: Text('Theme')),
            error: (_, __) => const SizedBox.shrink(),
            data: (mode) => ListTile(
              title: const Text('Theme'),
              subtitle: Text(switch (mode) {
                ThemeMode.system => 'System',
                ThemeMode.light => 'Light',
                ThemeMode.dark => 'Dark',
              }),
              trailing: SegmentedButton<ThemeMode>(
                selected: {mode},
                onSelectionChanged: (s) =>
                    ref.read(appThemeModeProvider.notifier).setMode(s.first),
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.system,
                    icon: Icon(Icons.brightness_auto),
                    tooltip: 'System',
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    icon: Icon(Icons.light_mode),
                    tooltip: 'Light',
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    icon: Icon(Icons.dark_mode),
                    tooltip: 'Dark',
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          const _SectionHeader('Notes'),
          sortAsync.when(
            loading: () => const ListTile(title: Text('Sort by')),
            error: (_, __) => const SizedBox.shrink(),
            data: (sort) => ListTile(
              title: const Text('Sort by'),
              subtitle: Text(sort.displayName),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showSortPicker(context, ref, sort),
            ),
          ),
          const Divider(),
          const _SectionHeader('About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            subtitle: Text('1.0.0 — MVP'),
          ),
        ],
      ),
    );
  }

  void _showSortPicker(
      BuildContext ctx, WidgetRef ref, NotesSortOrder current) {
    showModalBottomSheet<void>(
      context: ctx,
      builder: (_) => RadioGroup<NotesSortOrder>(
        groupValue: current,
        onChanged: (v) {
          if (v != null) {
            ref.read(notesSortPreferenceProvider.notifier).setOrder(v);
            Navigator.pop(ctx);
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: NotesSortOrder.values
              .map(
                (o) => ListTile(
                  leading: Radio<NotesSortOrder>(value: o),
                  title: Text(o.displayName),
                  onTap: () {
                    ref
                        .read(notesSortPreferenceProvider.notifier)
                        .setOrder(o);
                    Navigator.pop(ctx);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              letterSpacing: 1.2,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
