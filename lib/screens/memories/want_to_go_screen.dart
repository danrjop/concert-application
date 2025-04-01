import 'package:flutter/material.dart';
import '../../widgets/memories/index.dart';

class WantToGoScreen extends StatefulWidget {
  final List<String> activeFilters;

  const WantToGoScreen({
    super.key,
    required this.activeFilters,
  });

  @override
  State<WantToGoScreen> createState() => _WantToGoScreenState();
}

class _WantToGoScreenState extends State<WantToGoScreen> {
  // In a real app, you would fetch and store upcoming concerts the user wants to attend
  // This would include saved/bookmarked events

  @override
  Widget build(BuildContext context) {
    return FilteredContentTab(
      tabLabel: 'Want to go',
      activeFilters: widget.activeFilters,
    );
  }
}
