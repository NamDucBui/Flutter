import 'package:flutter/material.dart';

/// RichText widget that highlights all occurrences of [query] in [text].
class SearchHighlightTextWidget extends StatelessWidget {
  final String text;
  final String query;
  final int maxLines;
  final TextStyle? style;

  const SearchHighlightTextWidget({
    super.key,
    required this.text,
    required this.query,
    this.maxLines = 3,
    this.style,
  });

  List<TextSpan> _buildSpans(BuildContext context) {
    if (query.isEmpty) return [TextSpan(text: text, style: style)];
    final spans = <TextSpan>[];
    final lower = text.toLowerCase();
    final queryLower = query.toLowerCase();
    int start = 0;
    while (true) {
      final idx = lower.indexOf(queryLower, start);
      if (idx == -1) {
        spans.add(TextSpan(text: text.substring(start), style: style));
        break;
      }
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx), style: style));
      }
      spans.add(TextSpan(
        text: text.substring(idx, idx + query.length),
        style: (style ?? const TextStyle()).copyWith(
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ));
      start = idx + query.length;
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: style ?? DefaultTextStyle.of(context).style,
        children: _buildSpans(context),
      ),
    );
  }
}
