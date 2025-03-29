import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class MemoriesScreen extends StatefulWidget {
  const MemoriesScreen({super.key});

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
  
  // Filter states
  String? _selectedCity;
  bool _isOpenNow = false;
  String? _selectedGenre;

  // Available filter options
  final List<String> _cities = ['All', 'New York', 'Los Angeles', 'Chicago', 'Miami', 'Austin'];
  final List<String> _genres = ['All', 'Rock', 'Pop', 'Hip Hop', 'EDM', 'Jazz', 'Classical'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabLabels.length, vsync: this);
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
                // Return different content based on the tab
                if (label == 'Scrapbooks') {
                  return const Center(
                    child: Text('Scrapbooks Content'),
                  );
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
