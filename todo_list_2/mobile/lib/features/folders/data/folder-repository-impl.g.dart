// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder-repository-impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for FolderRepository.

@ProviderFor(folderRepository)
final folderRepositoryProvider = FolderRepositoryProvider._();

/// Riverpod provider for FolderRepository.

final class FolderRepositoryProvider
    extends
        $FunctionalProvider<
          FolderRepository,
          FolderRepository,
          FolderRepository
        >
    with $Provider<FolderRepository> {
  /// Riverpod provider for FolderRepository.
  FolderRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'folderRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$folderRepositoryHash();

  @$internal
  @override
  $ProviderElement<FolderRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FolderRepository create(Ref ref) {
    return folderRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FolderRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FolderRepository>(value),
    );
  }
}

String _$folderRepositoryHash() => r'4fbe5948a6ff056e8c395feae9a04c2761cb92e3';
