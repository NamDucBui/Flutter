// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note-repository-impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for NoteRepository.

@ProviderFor(noteRepository)
final noteRepositoryProvider = NoteRepositoryProvider._();

/// Riverpod provider for NoteRepository.

final class NoteRepositoryProvider
    extends $FunctionalProvider<NoteRepository, NoteRepository, NoteRepository>
    with $Provider<NoteRepository> {
  /// Riverpod provider for NoteRepository.
  NoteRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noteRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$noteRepositoryHash();

  @$internal
  @override
  $ProviderElement<NoteRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NoteRepository create(Ref ref) {
    return noteRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NoteRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NoteRepository>(value),
    );
  }
}

String _$noteRepositoryHash() => r'de572ed0be2b4553ebaaa42ad9355bf09f1b6651';
