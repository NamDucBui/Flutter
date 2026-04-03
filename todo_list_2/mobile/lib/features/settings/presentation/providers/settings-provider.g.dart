// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings-provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Persisted theme mode preference (System / Light / Dark).

@ProviderFor(AppThemeMode)
final appThemeModeProvider = AppThemeModeProvider._();

/// Persisted theme mode preference (System / Light / Dark).
final class AppThemeModeProvider
    extends $AsyncNotifierProvider<AppThemeMode, ThemeMode> {
  /// Persisted theme mode preference (System / Light / Dark).
  AppThemeModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appThemeModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appThemeModeHash();

  @$internal
  @override
  AppThemeMode create() => AppThemeMode();
}

String _$appThemeModeHash() => r'b234c81671b4978a6759f8c248fd5203627cc2b7';

/// Persisted theme mode preference (System / Light / Dark).

abstract class _$AppThemeMode extends $AsyncNotifier<ThemeMode> {
  FutureOr<ThemeMode> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ThemeMode>, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ThemeMode>, ThemeMode>,
              AsyncValue<ThemeMode>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Persisted notes sort order preference.

@ProviderFor(NotesSortPreference)
final notesSortPreferenceProvider = NotesSortPreferenceProvider._();

/// Persisted notes sort order preference.
final class NotesSortPreferenceProvider
    extends $AsyncNotifierProvider<NotesSortPreference, NotesSortOrder> {
  /// Persisted notes sort order preference.
  NotesSortPreferenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notesSortPreferenceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notesSortPreferenceHash();

  @$internal
  @override
  NotesSortPreference create() => NotesSortPreference();
}

String _$notesSortPreferenceHash() =>
    r'f29a2df56ac913672fa51bdb3711ad700cae487f';

/// Persisted notes sort order preference.

abstract class _$NotesSortPreference extends $AsyncNotifier<NotesSortOrder> {
  FutureOr<NotesSortOrder> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<NotesSortOrder>, NotesSortOrder>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<NotesSortOrder>, NotesSortOrder>,
              AsyncValue<NotesSortOrder>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
