import 'package:flutter/material.dart';
import '../../widgets/memories/index.dart';
import '../../widgets/memories/recs/recs_concert_list_item.dart';
import '../../models/index.dart';
import '../../constants/app_constants.dart';

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
  // List of concerts
  late List<Concert> _allConcerts;
  List<Concert> _filteredConcerts = [];
  
  // Search state
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Sort state (reusing the same sort options as in BeenScreen)
  ConcertSortOption _currentSortOption = ConcertSortOption.ratingDesc;
  
  @override
  void initState() {
    super.initState();
    // Generate sample concerts for the Recs section
    // In a real app, these would be fetched from a database or recommendation API
    _allConcerts = Concert.generateDummyConcerts(18);
    
    // Initialize filtered list and apply default sorting
    _filteredConcerts = List.from(_allConcerts);
    _applySortAndFilters();
  }
  
  @override
  void didUpdateWidget(RecsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeFilters != widget.activeFilters) {
      _applySortAndFilters();
    }
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  // Handle search input
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applySortAndFilters();
    });
  }
  
  // Clear search
  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _applySortAndFilters();
    });
  }
  
  // Handle sort option selection
  void _onSortOptionSelected(ConcertSortOption option) {
    setState(() {
      _currentSortOption = option;
      _sortConcerts();
    });
  }
  
  // Apply all filters and sorting
  void _applySortAndFilters() {
    _filterConcerts();
    _sortConcerts();
  }
  
  // Filter concerts based on search query and active filters
  void _filterConcerts() {
    setState(() {
      _filteredConcerts = _allConcerts.where((concert) {
        // Apply search query
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          if (!concert.name.toLowerCase().contains(query) &&
              !concert.venue.toLowerCase().contains(query) &&
              !concert.artists.any((artist) => artist.toLowerCase().contains(query)) &&
              !concert.genres.any((genre) => genre.toLowerCase().contains(query))) {
            return false;
          }
        }
        
        // Apply active filters
        for (final filter in widget.activeFilters) {
          if (filter == 'Open Now') {
            // Skip this filter for past concerts
            continue;
          }
          
          // City/Location filter
          if (_cities.contains(filter) && !concert.venue.contains(filter)) {
            return false;
          }
          
          // Genre filter
          if (_genres.contains(filter) && !concert.genres.contains(filter)) {
            return false;
          }
        }
        
        return true;
      }).toList();
    });
  }
  
  // Sort concerts based on the selected option
  void _sortConcerts() {
    if (_filteredConcerts.isEmpty) return;
    
    setState(() {
      switch (_currentSortOption) {
        case ConcertSortOption.artistAsc:
          _filteredConcerts.sort((a, b) => 
            a.artists.first.toLowerCase().compareTo(b.artists.first.toLowerCase()));
          break;
        case ConcertSortOption.artistDesc:
          _filteredConcerts.sort((a, b) => 
            b.artists.first.toLowerCase().compareTo(a.artists.first.toLowerCase()));
          break;
        case ConcertSortOption.venueAsc:
          _filteredConcerts.sort((a, b) => 
            a.venue.toLowerCase().compareTo(b.venue.toLowerCase()));
          break;
        case ConcertSortOption.venueDesc:
          _filteredConcerts.sort((a, b) => 
            b.venue.toLowerCase().compareTo(a.venue.toLowerCase()));
          break;
        case ConcertSortOption.genreAsc:
          _filteredConcerts.sort((a, b) => 
            a.genres.first.toLowerCase().compareTo(b.genres.first.toLowerCase()));
          break;
        case ConcertSortOption.genreDesc:
          _filteredConcerts.sort((a, b) => 
            b.genres.first.toLowerCase().compareTo(a.genres.first.toLowerCase()));
          break;
        case ConcertSortOption.ratingDesc:
          _filteredConcerts.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case ConcertSortOption.ratingAsc:
          _filteredConcerts.sort((a, b) => a.rating.compareTo(b.rating));
          break;
        case ConcertSortOption.dateDesc:
          _filteredConcerts.sort((a, b) => b.date.compareTo(a.date));
          break;
        case ConcertSortOption.dateAsc:
          _filteredConcerts.sort((a, b) => a.date.compareTo(b.date));
          break;
      }
    });
  }
  
  // Example filter options - typically these would come from a global configuration
  final List<String> _cities = [
    'New York', 'Los Angeles', 'Chicago', 'Austin', 'Miami'
  ];
  
  final List<String> _genres = [
    'Rock', 'Pop', 'Hip Hop', 'EDM', 'Jazz', 'Classical'
  ];

  // Handler for adding to want to go section
  void _onAddToWantToGo(Concert concert) {
    // In a real app, this would add the concert to the Want to Go section
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${concert.name} to your Want to Go list'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Handler for hiding a recommendation
  void _onHideRec(Concert concert) {
    // Remove the concert from the list
    setState(() {
      _allConcerts.removeWhere((c) => c.id == concert.id);
      _filteredConcerts.removeWhere((c) => c.id == concert.id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed ${concert.name} from your recommendations'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Close keyboard when tapping outside of search field
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search and Sort row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sort dropdown on the left
                SortDropdown(
                  currentSortOption: _currentSortOption,
                  onSortOptionSelected: _onSortOptionSelected,
                  tabType: SortTabType.recs,
                ),
                
                // Search bar on the right
                ConcertSearchBar(
                  controller: _searchController,
                  onSearch: _onSearchChanged,
                  onClear: _clearSearch,
                  hasSearchTerm: _searchQuery.isNotEmpty,
                ),
              ],
            ),
          ),
          
          // Active filters
          if (widget.activeFilters.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final filter in widget.activeFilters)
                    Chip(
                      label: Text(filter),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: AppConstants.primaryColor,
                      ),
                      backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    ),
                ],
              ),
            ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          
          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              '${_filteredConcerts.length} concerts recommended for you',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          
          // Concert list
          Expanded(
            child: _filteredConcerts.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: _filteredConcerts.length,
                    itemBuilder: (context, index) {
                      final concert = _filteredConcerts[index];
                      return RecsConcertListItem(
                        concert: concert,
                        index: index,
                        onTap: () {
                          // Show a sample action when tapping on a concert
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Tapped ${concert.name}'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        onAddToWantToGo: () => _onAddToWantToGo(concert),
                        onHideRec: () => _onHideRec(concert),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  // Empty state widget shown when no concerts match
  Widget _buildEmptyState() {
    String message = 'No concerts found';
    
    if (widget.activeFilters.isNotEmpty && _searchQuery.isNotEmpty) {
      message = 'No recommendations match your filters and search query';
    } else if (widget.activeFilters.isNotEmpty) {
      message = 'No recommendations match your filters';
    } else if (_searchQuery.isNotEmpty) {
      message = 'No recommendations match your search query';
    } else {
      message = 'No concert recommendations available yet';
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.recommend,
            size: 64,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (widget.activeFilters.isEmpty && _searchQuery.isEmpty)
            ElevatedButton(
              onPressed: () {
                // In a real app, this would refresh recommendations
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Refreshing recommendations...'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppConstants.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Refresh Recommendations'),
            ),
        ],
      ),
    );
  }
}
