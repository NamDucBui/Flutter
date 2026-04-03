// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search-filters-provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SearchFiltersNotifier)
final searchFiltersProvider = SearchFiltersNotifierProvider._();

final class SearchFiltersNotifierProvider
    extends $NotifierProvider<SearchFiltersNotifier, SearchFilters> {
  SearchFiltersNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchFiltersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchFiltersNotifierHash();

  @$internal
  @override
  SearchFiltersNotifier create() => SearchFiltersNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchFilters value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchFilters>(value),
    );
  }
}

String _$searchFiltersNotifierHash() =>
    r'a6e4012633062127e38be4f9576954f9d62e0adc';

abstract class _$SearchFiltersNotifier extends $Notifier<SearchFilters> {
  SearchFilters build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SearchFilters, SearchFilters>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchFilters, SearchFilters>,
              SearchFilters,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
