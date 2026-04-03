import 'package:flutter/material.dart';
import '../../domain/tag-entity.dart';

/// A compact colored chip displaying a tag name.
class TagChipWidget extends StatelessWidget {
  final TagEntity tag;
  final bool isSelected;
  final VoidCallback? onTap;

  const TagChipWidget({
    super.key,
    required this.tag,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(tag.color.replaceFirst('#', '0xFF')));
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text('#${tag.name}'),
        backgroundColor: isSelected
            ? color.withValues(alpha: 0.3)
            : color.withValues(alpha: 0.15),
        side: BorderSide(
          color: isSelected ? color : Colors.transparent,
        ),
        labelStyle: TextStyle(
          color: color.withValues(alpha: 0.9),
          fontSize: 12,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 2),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
