import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class FilteredContentTab extends StatelessWidget {
  final String tabLabel;
  final List<String> activeFilters;

  const FilteredContentTab({
    super.key,
    required this.tabLabel,
    required this.activeFilters,
  });

  @override
  Widget build(BuildContext context) {
    String filterText = activeFilters.isEmpty 
        ? 'No filters applied' 
        : 'Filters: ${activeFilters.join(', ')}';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$tabLabel Content',
            style: AppConstants.subtitleStyle,
          ),
          const SizedBox(height: 16),
          Text(
            filterText,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
