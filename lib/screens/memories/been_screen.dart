import 'package:flutter/material.dart';
import '../../widgets/memories/index.dart';

class BeenScreen extends StatefulWidget {
  final List<String> activeFilters;

  const BeenScreen({
    super.key,
    required this.activeFilters,
  });

  @override
  State<BeenScreen> createState() => _BeenScreenState();
}

class _BeenScreenState extends State<BeenScreen> {
  // In a real app, you would fetch and store past concerts data here
  // This would include user-specific concert history

  @override
  Widget build(BuildContext context) {
    return FilteredContentTab(
      tabLabel: 'Been',
      activeFilters: widget.activeFilters,
    );
  }
}
