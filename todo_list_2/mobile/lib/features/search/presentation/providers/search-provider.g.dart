// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search-provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Debounced search query state (300ms).

@ProviderFor(SearchQuery)
final searchQueryProvider = SearchQueryProvider._();

/// Debounced search query state (300ms).
final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  /// Debounced search query state (300ms).
  SearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'049c1a4d86708277dc73d797c9df8b7adbddb600';

/// Debounced search query state (300ms).

abstract class _$SearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Persisted recent search queries.

@ProviderFor(recentSearches)
final recentSearchesProvider = RecentSearchesProvider._();

/// Persisted recent search queries.

final class RecentSearchesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// Persisted recent search queries.
  RecentSearchesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentSearchesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentSearchesHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return recentSearches(ref);
  }
}

String _$recentSearchesHash() => r'e9513b44d5a3734559e337bab6da5073f84720bb';

/// Search results filtered by active filters.

@ProviderFor(searchResults)
final searchResultsProvider = SearchResultsProvider._();

/// Search results filtered by active filters.

final class SearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NoteEntity>>,
          List<NoteEntity>,
          FutureOr<List<NoteEntity>>
        >
    with $FutureModifier<List<NoteEntity>>, $FutureProvider<List<NoteEntity>> {
  /// Search results filtered by active filters.
  SearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<NoteEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NoteEntity>> create(Ref ref) {
    return searchResults(ref);
  }
}

String _$searchResultsHash() => r'f18a28a4836578d8a44b3be4e22abbe0f4116b84';
