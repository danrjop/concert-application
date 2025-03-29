import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'main_navigation_screen.dart';

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
  bool _isOpenNow = false;
  String? _selectedGenre;

  // Available filter options
  final List<String> _cities = ['All', 'New York', 'Los Angeles', 'Chicago', 'Miami', 'Austin'];
  final List<String> _genres = ['All', 'Rock', 'Pop', 'Hip Hop', 'EDM', 'Jazz', 'Classical'];

  // Mock data for scrapbooks - in a real app this would come from a database
  final Map<int, List<ScrapbookItem>> _scrapbooksByYear = {
    2025: [
      ScrapbookItem(id: '1', title: 'EDC Las Vegas', date: 'May 15, 2025', imageUrl: 'assets/images/concert1.jpg'),
      ScrapbookItem(id: '2', title: 'Coachella', date: 'April 10, 2025', imageUrl: 'assets/images/concert2.jpg'),
    ],
    2024: [
      ScrapbookItem(id: '3', title: 'Lollapalooza', date: 'August 3, 2024', imageUrl: 'assets/images/concert3.jpg'),
      ScrapbookItem(id: '4', title: 'Rolling Loud', date: 'July 25, 2024', imageUrl: 'assets/images/concert4.jpg'),
      ScrapbookItem(id: '5', title: 'Ultra Music Festival', date: 'March 22, 2024', imageUrl: 'assets/images/concert5.jpg'),
    ],
    2023: [
      ScrapbookItem(id: '6', title: 'Glastonbury', date: 'June 21, 2023', imageUrl: 'assets/images/concert6.jpg'),
      ScrapbookItem(id: '7', title: 'Tomorrowland', date: 'July 20, 2023', imageUrl: 'assets/images/concert7.jpg'),
    ],
    2022: [
      ScrapbookItem(id: '8', title: 'Burning Man', date: 'August 28, 2022', imageUrl: 'assets/images/concert8.jpg'),
    ],
  };

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

  // Show the advanced filter bottom sheet
  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              expand: false,
              builder: (_, scrollController) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Advanced Filters',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const Divider(),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          children: [
                            const Text(
                              'City',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              children: _cities.map((city) {
                                return FilterChip(
                                  label: Text(city),
                                  selected: _selectedCity == city,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedCity = selected ? city : _cities.first;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),
                            
                            const Text(
                              'Genre',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              children: _genres.map((genre) {
                                return FilterChip(
                                  label: Text(genre),
                                  selected: _selectedGenre == genre,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedGenre = selected ? genre : _genres.first;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),
                            
                            SwitchListTile(
                              title: const Text('Open Now'),
                              value: _isOpenNow,
                              onChanged: (value) {
                                setState(() {
                                  _isOpenNow = value;
                                });
                              },
                            ),
                            
                            // Additional filter options could be added here
                            const SizedBox(height: 20),
                            
                            // Price Range Slider
                            const Text(
                              'Price Range',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            RangeSlider(
                              values: const RangeValues(0, 100),
                              min: 0,
                              max: 200,
                              divisions: 10,
                              labels: const RangeLabels('\$0', '\$100'),
                              onChanged: (RangeValues values) {
                                // Handle price range changes
                              },
                            ),
                            
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () {
                                // Apply the filters and close the sheet
                                this.setState(() {
                                  // Update main screen state with these filter values
                                  this._selectedCity = _selectedCity;
                                  this._selectedGenre = _selectedGenre;
                                  this._isOpenNow = _isOpenNow;
                                });
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.primaryColor,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Apply Filters',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // Show the create new scrapbook dialog
  void _showCreateScrapbookDialog(int year) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Scrapbook'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Concert Title',
                hintText: 'Enter concert name',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: 'MM/DD/YYYY',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              // This would add a new scrapbook in a real app
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('New scrapbook created for $year')),
              );
            },
            child: const Text('CREATE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Memories',
          style: AppConstants.titleStyle,
        ),
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
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
          // Concerts Title (clickable button)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextButton(
              onPressed: () {
                // Concert button functionality will be implemented later
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                alignment: Alignment.centerLeft,
              ),
              child: const Text(
                'Concerts',
                style: AppConstants.subtitleStyle,
              ),
            ),
          ),
          
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Advanced Filter Button
                    FilterChip(
                      label: const Row(
                        children: [
                          Icon(Icons.tune, size: 18),
                          SizedBox(width: 4),
                          Text('Filter'),
                        ],
                      ),
                      onSelected: (_) => _showAdvancedFilters(),
                      selected: false,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // City Filter
                    FilterChip(
                      label: Text(_selectedCity == _cities.first ? 'City' : _selectedCity!),
                      selected: _selectedCity != _cities.first,
                      onSelected: (_) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => ListView.builder(
                            itemCount: _cities.length,
                            itemBuilder: (context, index) => ListTile(
                              title: Text(_cities[index]),
                              selected: _selectedCity == _cities[index],
                              onTap: () {
                                setState(() {
                                  _selectedCity = _cities[index];
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // Open Now Filter
                    FilterChip(
                      label: const Text('Open Now'),
                      selected: _isOpenNow,
                      onSelected: (selected) {
                        setState(() {
                          _isOpenNow = selected;
                        });
                      },
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    // Genre Filter
                    FilterChip(
                      label: Text(_selectedGenre == _genres.first ? 'Genre' : _selectedGenre!),
                      selected: _selectedGenre != _genres.first,
                      onSelected: (_) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => ListView.builder(
                            itemCount: _genres.length,
                            itemBuilder: (context, index) => ListTile(
                              title: Text(_genres[index]),
                              selected: _selectedGenre == _genres[index],
                              onTap: () {
                                setState(() {
                                  _selectedGenre = _genres[index];
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Content area - TabBarView to show content for each tab
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabLabels.map((label) {
                if (label == 'Scrapbooks') {
                  return _buildScrapbooksTimeline();
                } else {
                  // Content for tabs that have filters
                  return _buildFilteredContent(label);
                }
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
  
  // Build the scrapbooks timeline
  Widget _buildScrapbooksTimeline() {
    // Get years in descending order (most recent first)
    final List<int> years = _scrapbooksByYear.keys.toList()..sort((a, b) => b.compareTo(a));
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: years.length,
      itemBuilder: (context, index) {
        final year = years[index];
        final scrapbooks = _scrapbooksByYear[year]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Year header
            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 12),
              child: Text(
                year.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Grid of scrapbook cards
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: scrapbooks.length + 1, // +1 for the "Add" card
              itemBuilder: (context, cardIndex) {
                if (cardIndex == 0) {
                  // "Add new" card (always first)
                  return _buildAddScrapbookCard(year);
                } else {
                  // Regular scrapbook card
                  final scrapbook = scrapbooks[cardIndex - 1];
                  return _buildScrapbookCard(scrapbook);
                }
              },
            ),
            
            // Divider between years
            if (index < years.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(),
              ),
          ],
        );
      },
    );
  }
  
  // Build the "Add new scrapbook" card
  Widget _buildAddScrapbookCard(int year) {
    return InkWell(
      onTap: () => _showCreateScrapbookDialog(year),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 40,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
  
  // Build a scrapbook card
  Widget _buildScrapbookCard(ScrapbookItem scrapbook) {
    return InkWell(
      onTap: () {
        // Navigate to scrapbook detail view (to be implemented)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening scrapbook: ${scrapbook.title}')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300], // Placeholder for actual images
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // This would be an actual Image widget in a real app
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.grey[400], // Placeholder for image
                child: Center(
                  child: Icon(
                    Icons.music_note,
                    size: 30,
                    color: Colors.grey[100],
                  ),
                ),
              ),
            ),
            
            // Title overlay at the bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Text(
                  scrapbook.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build content with applied filters
  Widget _buildFilteredContent(String tabLabel) {
    // Construct filter description text
    List<String> activeFilters = [];
    if (_selectedCity != _cities.first) activeFilters.add(_selectedCity!);
    if (_selectedGenre != _genres.first) activeFilters.add(_selectedGenre!);
    if (_isOpenNow) activeFilters.add('Open Now');
    
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

// Data model for a scrapbook item
class ScrapbookItem {
  final String id;
  final String title;
  final String date;
  final String imageUrl;

  ScrapbookItem({
    required this.id,
    required this.title,
    required this.date,
    required this.imageUrl,
  });
}
