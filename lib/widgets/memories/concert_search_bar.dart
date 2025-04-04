import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class ConcertSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final VoidCallback onClear;
  final bool hasSearchTerm;

  const ConcertSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onClear,
    required this.hasSearchTerm,
  });

  @override
  State<ConcertSearchBar> createState() => _ConcertSearchBarState();
}

class _ConcertSearchBarState extends State<ConcertSearchBar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _isExpanded) {
      _collapse();
    }
  }

  void _expand() {
    setState(() {
      _isExpanded = true;
    });
    _animationController.forward();
    
    // Request focus after expanding
    Future.delayed(const Duration(milliseconds: 100), () {
      _focusNode.requestFocus();
    });
  }

  void _collapse() {
    // Don't collapse if there's search text
    if (widget.hasSearchTerm) return;
    
    setState(() {
      _isExpanded = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isExpanded ? null : _expand,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: _isExpanded ? 160 : 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: _isExpanded
            ? TextField(
                controller: widget.controller,
                focusNode: _focusNode,
                onChanged: widget.onSearch,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: const TextStyle(fontSize: 14),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade600,
                    size: 16,
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  suffixIcon: widget.hasSearchTerm
                      ? GestureDetector(
                          onTap: widget.onClear,
                          child: const Icon(
                            Icons.clear,
                            color: Colors.grey,
                            size: 16,
                          ),
                        )
                      : null,
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 28,
                    minHeight: 32,
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 16,
                ),
              ),
      ),
    );
  }
}
