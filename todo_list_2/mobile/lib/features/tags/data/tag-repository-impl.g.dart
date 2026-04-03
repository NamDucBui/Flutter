// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag-repository-impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for TagRepository.

@ProviderFor(tagRepository)
final tagRepositoryProvider = TagRepositoryProvider._();

/// Riverpod provider for TagRepository.

final class TagRepositoryProvider
    extends $FunctionalProvider<TagRepository, TagRepository, TagRepository>
    with $Provider<TagRepository> {
  /// Riverpod provider for TagRepository.
  TagRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tagRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tagRepositoryHash();

  @$internal
  @override
  $ProviderElement<TagRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TagRepository create(Ref ref) {
    return tagRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TagRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TagRepository>(value),
    );
  }
}

String _$tagRepositoryHash() => r'684a44c0b6c2a40d85d1af865dd2f4dfa02bf021';
