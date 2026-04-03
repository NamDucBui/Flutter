import 'package:flutter/material.dart';

/// Predefined color palette for note backgrounds.
const noteColors = {
  '#FFFFFF': 'White',
  '#FFF9C4': 'Yellow',
  '#E8F5E9': 'Green',
  '#E3F2FD': 'Blue',
  '#FCE4EC': 'Pink',
  '#EDE7F6': 'Purple',
};

/// Converts a hex color string (e.g. '#FFF9C4') to a Flutter [Color].
Color hexToColor(String hex) =>
    Color(int.parse(hex.replaceFirst('#', '0xFF')));

/// Horizontal row of color swatches for selecting note background color.
class NoteColorPickerWidget extends StatelessWidget {
  final String selectedColor;
  final ValueChanged<String> onColorSelected;

  const NoteColorPickerWidget({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: noteColors.entries.map((e) {
          final isSelected = e.key == selectedColor;
          return Tooltip(
            message: e.value,
            child: GestureDetector(
              onTap: () => onColorSelected(e.key),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: hexToColor(e.key),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                    width: isSelected ? 3 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.3),
                            blurRadius: 6,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
