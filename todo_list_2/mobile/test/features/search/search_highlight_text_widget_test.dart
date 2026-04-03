import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notes_app/features/search/presentation/widgets/search-highlight-text-widget.dart';

void main() {
  group('SearchHighlightTextWidget', () {
    testWidgets('highlights matching query text with background color',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SearchHighlightTextWidget(
              text: 'Hello Flutter World',
              query: 'Flutter',
            ),
          ),
        ),
      );

      final richText =
          tester.widget<RichText>(find.byType(RichText).first);
      final root = richText.text as TextSpan;

      // Collect all leaf spans recursively.
      final allSpans = <TextSpan>[];
      root.visitChildren((s) {
        if (s is TextSpan) allSpans.add(s);
        return true;
      });

      expect(
        allSpans.any((s) => s.style?.backgroundColor != null),
        isTrue,
        reason: 'Expected at least one span with a highlight background',
      );
    });

    testWidgets('renders plain text (no highlights) when query is empty',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SearchHighlightTextWidget(
              text: 'Hello World',
              query: '',
            ),
          ),
        ),
      );

      final richText =
          tester.widget<RichText>(find.byType(RichText).first);
      final root = richText.text as TextSpan;

      final allSpans = <TextSpan>[];
      root.visitChildren((s) {
        if (s is TextSpan) allSpans.add(s);
        return true;
      });

      expect(
        allSpans.every((s) => s.style?.backgroundColor == null),
        isTrue,
        reason: 'No spans should be highlighted when query is empty',
      );
    });

    testWidgets('is case-insensitive when matching query', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SearchHighlightTextWidget(
              text: 'Hello Flutter World',
              query: 'flutter', // lowercase
            ),
          ),
        ),
      );

      final richText =
          tester.widget<RichText>(find.byType(RichText).first);
      final root = richText.text as TextSpan;

      final allSpans = <TextSpan>[];
      root.visitChildren((s) {
        if (s is TextSpan) allSpans.add(s);
        return true;
      });

      expect(
        allSpans.any((s) => s.style?.backgroundColor != null),
        isTrue,
        reason: 'Should highlight regardless of case',
      );
    });
  });
}
