// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes-list-provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Streams all non-deleted notes, optionally filtered by folder.

@ProviderFor(notesList)
final notesListProvider = NotesListFamily._();

/// Streams all non-deleted notes, optionally filtered by folder.

final class NotesListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NoteEntity>>,
          List<NoteEntity>,
          Stream<List<NoteEntity>>
        >
    with $FutureModifier<List<NoteEntity>>, $StreamProvider<List<NoteEntity>> {
  /// Streams all non-deleted notes, optionally filtered by folder.
  NotesListProvider._({
    required NotesListFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'notesListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$notesListHash();

  @override
  String toString() {
    return r'notesListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<NoteEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<NoteEntity>> create(Ref ref) {
    final argument = this.argument as String?;
    return notesList(ref, folderId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NotesListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$notesListHash() => r'bbee45e0719d515469b3019736baf9d7a0d163b0';

/// Streams all non-deleted notes, optionally filtered by folder.

final class NotesListFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<NoteEntity>>, String?> {
  NotesListFamily._()
    : super(
        retry: null,
        name: r'notesListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Streams all non-deleted notes, optionally filtered by folder.

  NotesListProvider call({String? folderId}) =>
      NotesListProvider._(argument: folderId, from: this);

  @override
  String toString() => r'notesListProvider';
}

/// Splits notes into pinned and regular sections.

@ProviderFor(pinnedAndNotes)
final pinnedAndNotesProvider = PinnedAndNotesFamily._();

/// Splits notes into pinned and regular sections.

final class PinnedAndNotesProvider
    extends
        $FunctionalProvider<
          AsyncValue<(List<NoteEntity>, List<NoteEntity>)>,
          AsyncValue<(List<NoteEntity>, List<NoteEntity>)>,
          AsyncValue<(List<NoteEntity>, List<NoteEntity>)>
        >
    with $Provider<AsyncValue<(List<NoteEntity>, List<NoteEntity>)>> {
  /// Splits notes into pinned and regular sections.
  PinnedAndNotesProvider._({
    required PinnedAndNotesFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'pinnedAndNotesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pinnedAndNotesHash();

  @override
  String toString() {
    return r'pinnedAndNotesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<(List<NoteEntity>, List<NoteEntity>)>>
  $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  AsyncValue<(List<NoteEntity>, List<NoteEntity>)> create(Ref ref) {
    final argument = this.argument as String?;
    return pinnedAndNotes(ref, folderId: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    AsyncValue<(List<NoteEntity>, List<NoteEntity>)> value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<AsyncValue<(List<NoteEntity>, List<NoteEntity>)>>(
            value,
          ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PinnedAndNotesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pinnedAndNotesHash() => r'dd2a52d44351bdef0dbd51ed19fb23bf04360de0';

/// Splits notes into pinned and regular sections.

final class PinnedAndNotesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          AsyncValue<(List<NoteEntity>, List<NoteEntity>)>,
          String?
        > {
  PinnedAndNotesFamily._()
    : super(
        retry: null,
        name: r'pinnedAndNotesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Splits notes into pinned and regular sections.

  PinnedAndNotesProvider call({String? folderId}) =>
      PinnedAndNotesProvider._(argument: folderId, from: this);

  @override
  String toString() => r'pinnedAndNotesProvider';
}
