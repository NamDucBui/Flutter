// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note-editor-provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages note editor state with auto-save (debounced 500ms).

@ProviderFor(NoteEditor)
final noteEditorProvider = NoteEditorFamily._();

/// Manages note editor state with auto-save (debounced 500ms).
final class NoteEditorProvider
    extends $NotifierProvider<NoteEditor, AsyncValue<NoteEntity?>> {
  /// Manages note editor state with auto-save (debounced 500ms).
  NoteEditorProvider._({
    required NoteEditorFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'noteEditorProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$noteEditorHash();

  @override
  String toString() {
    return r'noteEditorProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  NoteEditor create() => NoteEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<NoteEntity?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<NoteEntity?>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is NoteEditorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$noteEditorHash() => r'f55a81fed1a11576e21653b631664ebf228e3747';

/// Manages note editor state with auto-save (debounced 500ms).

final class NoteEditorFamily extends $Family
    with
        $ClassFamilyOverride<
          NoteEditor,
          AsyncValue<NoteEntity?>,
          AsyncValue<NoteEntity?>,
          AsyncValue<NoteEntity?>,
          String?
        > {
  NoteEditorFamily._()
    : super(
        retry: null,
        name: r'noteEditorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Manages note editor state with auto-save (debounced 500ms).

  NoteEditorProvider call(String? noteId) =>
      NoteEditorProvider._(argument: noteId, from: this);

  @override
  String toString() => r'noteEditorProvider';
}

/// Manages note editor state with auto-save (debounced 500ms).

abstract class _$NoteEditor extends $Notifier<AsyncValue<NoteEntity?>> {
  late final _$args = ref.$arg as String?;
  String? get noteId => _$args;

  AsyncValue<NoteEntity?> build(String? noteId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<NoteEntity?>, AsyncValue<NoteEntity?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<NoteEntity?>, AsyncValue<NoteEntity?>>,
              AsyncValue<NoteEntity?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
