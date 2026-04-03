import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings-provider.g.dart';

/// Notes sort order options.
enum NotesSortOrder {
  modifiedDesc,
  modifiedAsc,
  createdDesc,
  titleAsc,
}

extension NotesSortOrderLabel on NotesSortOrder {
  String get displayName => switch (this) {
        NotesSortOrder.modifiedDesc => 'Date Modified ↓',
        NotesSortOrder.modifiedAsc => 'Date Modified ↑',
        NotesSortOrder.createdDesc => 'Date Created ↓',
        NotesSortOrder.titleAsc => 'Title A→Z',
      };
}

/// Persisted theme mode preference (System / Light / Dark).
@riverpod
class AppThemeMode extends _$AppThemeMode {
  static const _key = 'theme_mode';

  @override
  Future<ThemeMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    return ThemeMode.values.firstWhere(
      (m) => m.name == saved,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setMode(ThemeMode mode) async {
    state = AsyncValue.data(mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }
}

/// Persisted notes sort order preference.
@riverpod
class NotesSortPreference extends _$NotesSortPreference {
  static const _key = 'notes_sort';

  @override
  Future<NotesSortOrder> build() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    return NotesSortOrder.values.firstWhere(
      (o) => o.name == saved,
      orElse: () => NotesSortOrder.modifiedDesc,
    );
  }

  Future<void> setOrder(NotesSortOrder order) async {
    state = AsyncValue.data(order);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, order.name);
  }
}
