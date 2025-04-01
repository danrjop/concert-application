import 'package:flutter/material.dart';
import '../../widgets/memories/index.dart';

class TrendingScreen extends StatefulWidget {
  final List<String> activeFilters;

  const TrendingScreen({
    super.key,
    required this.activeFilters,
  });

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  // In a real app, you would fetch trending concerts data here
  // This would include popular events based on social metrics

  @override
  Widget build(BuildContext context) {
    return FilteredContentTab(
      tabLabel: 'Trending',
      activeFilters: widget.activeFilters,
    );
  }
}
