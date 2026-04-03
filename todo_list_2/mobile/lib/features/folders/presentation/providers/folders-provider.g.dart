// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folders-provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Streams all folders sorted alphabetically.

@ProviderFor(foldersList)
final foldersListProvider = FoldersListProvider._();

/// Streams all folders sorted alphabetically.

final class FoldersListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FolderEntity>>,
          List<FolderEntity>,
          Stream<List<FolderEntity>>
        >
    with
        $FutureModifier<List<FolderEntity>>,
        $StreamProvider<List<FolderEntity>> {
  /// Streams all folders sorted alphabetically.
  FoldersListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foldersListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foldersListHash();

  @$internal
  @override
  $StreamProviderElement<List<FolderEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<FolderEntity>> create(Ref ref) {
    return foldersList(ref);
  }
}

String _$foldersListHash() => r'7223cde885bd2354a03d909c244e50de2659c156';

/// Streams note count for a specific folder.

@ProviderFor(folderNoteCount)
final folderNoteCountProvider = FolderNoteCountFamily._();

/// Streams note count for a specific folder.

final class FolderNoteCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Streams note count for a specific folder.
  FolderNoteCountProvider._({
    required FolderNoteCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'folderNoteCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$folderNoteCountHash();

  @override
  String toString() {
    return r'folderNoteCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    final argument = this.argument as String;
    return folderNoteCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FolderNoteCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$folderNoteCountHash() => r'633470fb9a0fcfd2811cb3272069ff64fb126cd4';

/// Streams note count for a specific folder.

final class FolderNoteCountFamily extends $Family
    with $FunctionalFamilyOverride<Stream<int>, String> {
  FolderNoteCountFamily._()
    : super(
        retry: null,
        name: r'folderNoteCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Streams note count for a specific folder.

  FolderNoteCountProvider call(String folderId) =>
      FolderNoteCountProvider._(argument: folderId, from: this);

  @override
  String toString() => r'folderNoteCountProvider';
}

/// Currently selected folder UUID for filtering the notes list. null = All Notes.

@ProviderFor(SelectedFolder)
final selectedFolderProvider = SelectedFolderProvider._();

/// Currently selected folder UUID for filtering the notes list. null = All Notes.
final class SelectedFolderProvider
    extends $NotifierProvider<SelectedFolder, String?> {
  /// Currently selected folder UUID for filtering the notes list. null = All Notes.
  SelectedFolderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedFolderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedFolderHash();

  @$internal
  @override
  SelectedFolder create() => SelectedFolder();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedFolderHash() => r'29ba0ee69edd1e745f34241c380843e71a145e64';

/// Currently selected folder UUID for filtering the notes list. null = All Notes.

abstract class _$SelectedFolder extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
