// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app-router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// go_router configuration with ShellRoute for bottom navigation.
/// Editor routes (/notes/new, /notes/:id) are outside the shell so they
/// render without the bottom navigation bar.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// go_router configuration with ShellRoute for bottom navigation.
/// Editor routes (/notes/new, /notes/:id) are outside the shell so they
/// render without the bottom navigation bar.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// go_router configuration with ShellRoute for bottom navigation.
  /// Editor routes (/notes/new, /notes/:id) are outside the shell so they
  /// render without the bottom navigation bar.
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'eef126fcdede7863178367c54842eea6cf7b7db0';
