import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'main_navigation_screen.dart';
import 'memories/index.dart';
import '../widgets/memories/index.dart';

class MemoriesScreen extends StatefulWidget {
  // Optional parameter for which tab to select initially
  final int? initialTabIndex;
  const MemoriesScreen({super.key, this.initialTabIndex});

  @override
  State<MemoriesScreen> createState() => _MemoriesScreenState();
}

class _MemoriesScreenState extends State<MemoriesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabLabels = [
    'Scrapbooks', 
    'Been', 
    'Want to go', 
    'Recs', 
    'Trending'
  ];
  
  // Get the initial tab index to use
  int get _initialTabIndex {
    // Check if we have a specific tab to show from MainNavigationScreen
    if (MainNavigationScreenState.memoriesTabToSelect != null) {
      final index = MainNavigationScreenState.memoriesTabToSelect!;
      // Reset it so it's not used again
      MainNavigationScreenState.memoriesTabToSelect = null;
      return index;
    }
    // Otherwise check if the widget has an initialTabIndex
    if (widget.initialTabIndex != null) {
      return widget.initialTabIndex!;
    }
    // Default to the first tab (Scrapbooks)
    return 0;
  }
  
  // Filter states
  String? _selectedCity;
  bool _isComingSoon = false;
  int _comingSoonDays = 7; // Default to 7 days
  String? _selectedGenre;

  // Available filter options
  final List<String> _cities = ['All', 'New York', 'Los Angeles', 'Chicago', 'Miami', 'Austin'];
  final List<String> _genres = ['All', 'Rock', 'Pop', 'Hip Hop', 'EDM', 'Jazz', 'Classical'];

  @override
  void initState() {
    super.initState();
    // Initialize the tab controller with the correct initial tab
    _tabController = TabController(initialIndex: _initialTabIndex, length: _tabLabels.length, vsync: this);
    _tabController.addListener(_handleTabChange);
    _selectedCity = _cities.first;
    _selectedGenre = _genres.first;
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }
  
  // Public method to select a specific tab
  void selectTab(int index) {
    if (index >= 0 && index < _tabLabels.length) {
      // Use jumpTo instead of animateTo for immediate tab change without animation
      _tabController.index = index;
      setState(() {}); // Refresh UI to reflect the change
    }
  }

  // Determine if we should show the filter bar for the current tab
  bool get _shouldShowFilters {
    // Show filters for Been, Want to go, Recs, and Trending tabs
    return _tabController.index >= 1; // Index 1 is Been, 2 is Want to go, etc.
  }

  // Check if the current tab is the Been tab
  bool get _isBeenTab {
    return _tabController.index == 1; // Index 1 is the Been tab
  }

  // Show the advanced filter bottom sheet
  void _showAdvancedFilters() {
    if (_isBeenTab) {
      // For Been tab, show the specialized advanced filters without Coming Soon or Open Now
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return AdvancedFiltersForBeen(
            selectedCity: _selectedCity!,
            cities: _cities,
            selectedGenre: _selectedGenre!,
            genres: _genres,
            onApplyFilters: (city, genre) {
              setState(() {
                _selectedCity = city;
                _selectedGenre = genre;
              });
            },
          );
        },
      );
    } else {
      // For other tabs, show the advanced filters with Coming Soon
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return AdvancedFiltersWithComingSoon(
            selectedCity: _selectedCity!,
            cities: _cities,
            selectedGenre: _selectedGenre!,
            genres: _genres,
            isComingSoon: _isComingSoon,
            comingSoonDays: _comingSoonDays,
            onApplyFilters: (city, genre, comingSoon, days) {
              setState(() {
                _selectedCity = city;
                _selectedGenre = genre;
                _isComingSoon = comingSoon;
                _comingSoonDays = days;
              });
            },
          );
        },
      );
    }
  }

  // Get active filters for the current tab
  List<String> get _activeFilters {
    List<String> activeFilters = [];
    if (_selectedCity != _cities.first) activeFilters.add(_selectedCity!);
    if (_selectedGenre != _genres.first) activeFilters.add(_selectedGenre!);
    
    // Only add Coming Soon filter for tabs other than Been
    if (!_isBeenTab && _isComingSoon) {
      activeFilters.add('Coming Soon $_comingSoonDays days');
    }
    
    return activeFilters;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'My Memories',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppConstants.darkTextColor
                : AppConstants.textColor,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppConstants.darkTextColor
              : AppConstants.textColor,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // Share functionality will be implemented later
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Settings functionality will be implemented later
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // Standard Flutter TabBar with 5 options
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppConstants.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppConstants.primaryColor,
              indicatorWeight: 2,
              isScrollable: true,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
              tabs: _tabLabels.map((label) => Tab(text: label)).toList(),
            ),
          ),

          // Filter bar - visible only for specific tabs
          if (_shouldShowFilters)
            _isBeenTab
                ? FilterBarForBeen(
                    selectedCity: _selectedCity!,
                    cities: _cities,
                    selectedGenre: _selectedGenre!,
                    genres: _genres,
                    onAdvancedFiltersPressed: _showAdvancedFilters,
                    onCitySelected: (city) {
                      setState(() {
                        _selectedCity = city;
                      });
                    },
                    onGenreSelected: (genre) {
                      setState(() {
                        _selectedGenre = genre;
                      });
                    },
                  )
                : FilterBarWithComingSoon(
                    selectedCity: _selectedCity!,
                    cities: _cities,
                    selectedGenre: _selectedGenre!,
                    genres: _genres,
                    isComingSoon: _isComingSoon,
                    comingSoonDays: _comingSoonDays,
                    onAdvancedFiltersPressed: _showAdvancedFilters,
                    onCitySelected: (city) {
                      setState(() {
                        _selectedCity = city;
                      });
                    },
                    onComingSoonToggled: (value) {
                      setState(() {
                        _isComingSoon = value;
                      });
                    },
                    onGenreSelected: (genre) {
                      setState(() {
                        _selectedGenre = genre;
                      });
                    },
                  ),

          // Content area - TabBarView to show content for each tab
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabLabels.map((label) {
                if (label == 'Scrapbooks') {
                  return const ScrapbooksScreen();
                } else {
                  // Return the appropriate screen based on the tab label
                  switch (label) {
                    case 'Been':
                      return BeenScreen(activeFilters: _activeFilters);
                    case 'Want to go':
                      return WantToGoScreen(activeFilters: _activeFilters);
                    case 'Recs':
                      return RecsScreen(activeFilters: _activeFilters);
                    case 'Trending':
                      return TrendingScreen(activeFilters: _activeFilters);
                    default:
                      // This should never happen, but just in case
                      return const Center(child: Text('Unknown tab'));
                  }
                }
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
