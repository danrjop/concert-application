import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _showRecentSearches = false;
  
  // Mock data for recent searches - initialized as empty to avoid null check issues
  List<String> _recentConcertSearches = [
    'EDM Festival',
    'Jazz Club',
    'Rock Concert',
    'Local Bands',
    'Music Festival'
  ];
  
  List<String> _recentPeopleSearches = [
    'John Doe',
    'Jane Smith',
    'Mike Johnson',
    'Sarah Williams',
    'Alex Brown'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _showRecentSearches = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  bool get _isSearchingConcerts => _tabController.index == 0;

  Widget _buildConcertResults() {
    // Categories to display - some are standard, others could be personalized
    final List<Map<String, dynamic>> categories = [
      {
        'title': 'Raves',
        'subtitle': 'Subhead',
        'icon': Icons.music_note,
      },
      {
        'title': 'Small Venues',
        'subtitle': 'Subhead',
        'icon': Icons.location_on,
      },
      {
        'title': 'Trending',
        'subtitle': 'Subhead',
        'icon': Icons.trending_up,
      },
      {
        'title': 'Friend Recs',
        'subtitle': 'Subhead',
        'icon': Icons.people,
      },
      {
        'title': 'Upcoming',
        'subtitle': 'Subhead',
        'icon': Icons.event,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              // Navigate to specific list screen when tapped
              // This would be connected to actual data in production
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${category['title']} tapped'))
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Main content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          category['subtitle'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Visual indicator elements (placeholder shapes)
                  // These could be replaced with actual images or icons
                  // representing each category
                  const SizedBox(width: 8),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0E0E0),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPeopleResults() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: 5, // Demo data
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User ${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@username${index + 1}',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Follow'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  // Build the recent searches overlay
  Widget _buildRecentSearchesOverlay() {
    final List<String> recentSearches = _isSearchingConcerts 
        ? _recentConcertSearches 
        : _recentPeopleSearches;
        
    return Material(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppConstants.darkSurfaceColor
          : Colors.white,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Searches',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    // Clear all recent searches
                    setState(() {
                      if (_isSearchingConcerts) {
                        _recentConcertSearches = [];
                      } else {
                        _recentPeopleSearches = [];
                      }
                    });
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (recentSearches.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'No recent searches',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: recentSearches.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(recentSearches[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              // Create a new list to avoid modifying the list during build
                              if (_isSearchingConcerts) {
                                List<String> newList = List.from(_recentConcertSearches);
                                newList.removeAt(index);
                                _recentConcertSearches = newList;
                              } else {
                                List<String> newList = List.from(_recentPeopleSearches);
                                newList.removeAt(index);
                                _recentPeopleSearches = newList;
                              }
                            });
                          }
                        },
                      ),
                      onTap: () {
                        // Set search text and perform search
                        _searchController.text = recentSearches[index];
                        if (mounted) {
                          setState(() {
                            _showRecentSearches = false;
                          });
                        }
                        // Perform search
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Ensure pressing back button closes recent search overlay if it's open
      onWillPop: () async {
        if (_showRecentSearches) {
          setState(() {
            _showRecentSearches = false;
          });
          return false; // Prevent the back navigation
        }
        return true; // Allow the back navigation
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Header section with search
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // LOGO and close button (only shown when search overlay is active)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'LOGO',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_showRecentSearches)
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _showRecentSearches = false;
                              });
                            },
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Tab Bar for switching between concerts and people (using Flutter's TabBar)
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
                        tabs: const [
                          Tab(text: 'Concerts'),
                          Tab(text: 'People'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Search Bar
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showRecentSearches = true;
                        });
                      },
                      child: TextField(
                        controller: _searchController,
                        onTap: () {
                          setState(() {
                            _showRecentSearches = true;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: _isSearchingConcerts 
                              ? 'Search for concerts' 
                              : 'Search for people',
                          hintStyle: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).brightness == Brightness.dark
                              ? AppConstants.darkGreyColor
                              : Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 16,
                          ),
                        ),
                        onSubmitted: (value) {
                          // Perform search
                          setState(() {
                            _showRecentSearches = false;
                            // Add to recent searches if not empty
                            if (value.isNotEmpty) {
                              if (_isSearchingConcerts) {
                                if (!_recentConcertSearches.contains(value)) {
                                  List<String> newList = List.from(_recentConcertSearches);
                                  newList.insert(0, value);
                                  // Keep only the most recent 10 searches
                                  if (newList.length > 10) {
                                    newList = newList.sublist(0, 10);
                                  }
                                  _recentConcertSearches = newList;
                                }
                              } else {
                                if (!_recentPeopleSearches.contains(value)) {
                                  List<String> newList = List.from(_recentPeopleSearches);
                                  newList.insert(0, value);
                                  // Keep only the most recent 10 searches
                                  if (newList.length > 10) {
                                    newList = newList.sublist(0, 10);
                                  }
                                  _recentPeopleSearches = newList;
                                }
                              }
                            }
                          });
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Location (only shown when searching for concerts)
                    if (_isSearchingConcerts)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppConstants.darkGreyColor
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, size: 20),
                            const SizedBox(width: 8),
                            const Text('Your Location'),
                            const Spacer(),
                            Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              
              // Results Section or Recent Searches
              Expanded(
                child: _showRecentSearches
                    ? _buildRecentSearchesOverlay()
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _buildConcertResults(),
                          _buildPeopleResults(),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
