// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tags-provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Streams all tags.

@ProviderFor(tagsList)
final tagsListProvider = TagsListProvider._();

/// Streams all tags.

final class TagsListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TagEntity>>,
          List<TagEntity>,
          Stream<List<TagEntity>>
        >
    with $FutureModifier<List<TagEntity>>, $StreamProvider<List<TagEntity>> {
  /// Streams all tags.
  TagsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tagsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tagsListHash();

  @$internal
  @override
  $StreamProviderElement<List<TagEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TagEntity>> create(Ref ref) {
    return tagsList(ref);
  }
}

String _$tagsListHash() => r'96ba1e53f0b118d4f1388d7fc6a72d1462272b4a';

/// Manages which tag UUIDs are assigned to a specific note.

@ProviderFor(NoteTagsEditor)
final noteTagsEditorProvider = NoteTagsEditorFamily._();

/// Manages which tag UUIDs are assigned to a specific note.
final class NoteTagsEditorProvider
    extends $NotifierProvider<NoteTagsEditor, List<String>> {
  /// Manages which tag UUIDs are assigned to a specific note.
  NoteTagsEditorProvider._({
    required NoteTagsEditorFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'noteTagsEditorProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$noteTagsEditorHash();

  @override
  String toString() {
    return r'noteTagsEditorProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  NoteTagsEditor create() => NoteTagsEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is NoteTagsEditorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$noteTagsEditorHash() => r'6c96af6d3bd8563a7607aa42c52810666542120c';

/// Manages which tag UUIDs are assigned to a specific note.

final class NoteTagsEditorFamily extends $Family
    with
        $ClassFamilyOverride<
          NoteTagsEditor,
          List<String>,
          List<String>,
          List<String>,
          String
        > {
  NoteTagsEditorFamily._()
    : super(
        retry: null,
        name: r'noteTagsEditorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Manages which tag UUIDs are assigned to a specific note.

  NoteTagsEditorProvider call(String noteId) =>
      NoteTagsEditorProvider._(argument: noteId, from: this);

  @override
  String toString() => r'noteTagsEditorProvider';
}

/// Manages which tag UUIDs are assigned to a specific note.

abstract class _$NoteTagsEditor extends $Notifier<List<String>> {
  late final _$args = ref.$arg as String;
  String get noteId => _$args;

  List<String> build(String noteId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
