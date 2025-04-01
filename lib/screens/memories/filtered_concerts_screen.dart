import 'package:flutter/material.dart';
import '../../widgets/memories/filtered_content_tab.dart';

class FilteredConcertsScreen extends StatelessWidget {
  final String tabLabel;
  final List<String> activeFilters;

  const FilteredConcertsScreen({
    super.key,
    required this.tabLabel,
    required this.activeFilters,
  });

  @override
  Widget build(BuildContext context) {
    return FilteredContentTab(
      tabLabel: tabLabel,
      activeFilters: activeFilters,
    );
  }
}
