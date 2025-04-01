import 'package:flutter/material.dart';
import '../../widgets/memories/index.dart';

class RecsScreen extends StatefulWidget {
  final List<String> activeFilters;

  const RecsScreen({
    super.key,
    required this.activeFilters,
  });

  @override
  State<RecsScreen> createState() => _RecsScreenState();
}

class _RecsScreenState extends State<RecsScreen> {
  // In a real app, you would fetch and store recommended concerts based on user preferences
  // This would be algorithm-based recommendations

  @override
  Widget build(BuildContext context) {
    return FilteredContentTab(
      tabLabel: 'Recs',
      activeFilters: widget.activeFilters,
    );
  }
}
