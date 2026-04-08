import 'dart:async';
import 'package:flutter/material.dart';

/// Search bar có dropdown suggest tên thành phố.
/// [onSearch] gọi khi user chọn gợi ý hoặc bấm Enter.
/// [suggestionsFetcher] trả về list label gợi ý theo query.
class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final Future<List<String>> Function(String query) suggestionsFetcher;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
    required this.suggestionsFetcher,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _textController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();

  OverlayEntry? _overlayEntry;
  List<String> _suggestions = [];
  Timer? _debounce;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _textController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      // Delay để cho phép onTap của suggestion item kịp fire
      // trước khi overlay bị xóa do mất focus
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) _removeOverlay();
      });
    }
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      _updateSuggestions([]);
      return;
    }
    // Debounce 350ms để tránh gọi API mỗi lần gõ phím
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      if (!mounted) return;
      setState(() => _loading = true);
      final results = await widget.suggestionsFetcher(value);
      if (!mounted) return;
      setState(() => _loading = false);
      _updateSuggestions(results);
    });
  }

  void _updateSuggestions(List<String> list) {
    _suggestions = list;
    _removeOverlay();
    if (list.isNotEmpty && _focusNode.hasFocus) {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    _overlayEntry = _buildOverlayEntry();
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectSuggestion(String suggestion) {
    _textController.clear();
    _removeOverlay();
    _suggestions = [];
    _focusNode.unfocus();
    widget.onSearch(suggestion);
  }

  void _submitCurrentText() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _textController.clear();
    _removeOverlay();
    _suggestions = [];
    _focusNode.unfocus();
    widget.onSearch(text);
  }

  OverlayEntry _buildOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        width: _boxWidth,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, _inputHeight),
          child: _SuggestionDropdown(
            suggestions: _suggestions,
            onSelect: _selectSuggestion,
          ),
        ),
      ),
    );
  }

  // Ước tính chiều rộng/cao của text field (dùng cho overlay offset)
  double get _boxWidth => MediaQuery.of(context).size.width - 32 - 12 - 24;
  double get _inputHeight => 48;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: _textController,
        focusNode: _focusNode,
        style: const TextStyle(color: Colors.white),
        textInputAction: TextInputAction.search,
        onChanged: _onChanged,
        onSubmitted: (_) => _submitCurrentText(),
        decoration: InputDecoration(
          isDense: true,
          hintText: "Search city...",
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          suffixIcon: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white70,
                    ),
                  ),
                )
              : null,
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

class _SuggestionDropdown extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onSelect;

  const _SuggestionDropdown({
    required this.suggestions,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(12),
      color: Colors.grey[900]!.withValues(alpha: 0.95),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: suggestions.map((s) {
            return InkWell(
              onTap: () => onSelect(s),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white54, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        s,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
