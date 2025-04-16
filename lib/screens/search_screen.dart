import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/clickable_user_avatar.dart';
import '../widgets/user_profile_overlay.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool _showSearchOverlay = false;
  bool _isClosingOverlay = false;
  bool _isTyping = false;
  
  // Mock data for recent searches
  final List<String> _recentConcertSearches = [
    'EDM Festival',
    'Jazz Club',
    'Rock Concert',
    'Local Bands',
    'Music Festival'
  ];
  
  final List<String> _recentPeopleSearches = [
    'John Doe',
    'Jane Smith',
    'Mike Johnson',
    'Sarah Williams',
    'Alex Brown'
  ];

  // Mock data for autocomplete suggestions
  final List<String> _concertAutocompleteSuggestions = [
    'EDM Festivals in your area',
    'Electronic Dance Music events',
    'EDM concert tickets',
    'EDM artists near me',
    'Electronic music clubs'
  ];

  final List<String> _peopleAutocompleteSuggestions = [
    'John Smith',
    'John Doe',
    'John Walker',
    'Johnny Depp',
    'Jonathan Miller'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, animationDuration: const Duration(milliseconds: 150));
    _tabController.addListener(() {
      // Reset search text and update state at the BEGINNING of the tab change
      if (_tabController.indexIsChanging) {
        setState(() {
          if (_showSearchOverlay) {
            _searchController.clear();
            _isTyping = false;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  bool get _isSearchingConcerts => _tabController.index == 0;

  // Build the search overlay (recent searches or autocomplete suggestions)
  Widget _buildSearchOverlay() {
    // Determine which list to display based on tab and typing state
    List<String> displayList = [];
    String headerText = '';
    
    if (_isTyping) {
      // Show autocomplete suggestions
      if (_isSearchingConcerts) {
        displayList = _filterAutocompleteSuggestions(_concertAutocompleteSuggestions);
        headerText = 'Suggested Concerts';
      } else {
        displayList = _filterAutocompleteSuggestions(_peopleAutocompleteSuggestions);
        headerText = 'Suggested People';
      }
    } else {
      // Show recent searches
      if (_isSearchingConcerts) {
        displayList = _recentConcertSearches;
        headerText = 'Recent Concert Searches';
      } else {
        displayList = _recentPeopleSearches;
        headerText = 'Recent People Searches';
      }
    }

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: _isClosingOverlay ? 0.0 : 1.0, end: _isClosingOverlay ? 1.0 : 0.0),
      builder: (context, value, child) {
        return Transform.translate(
            offset: Offset(0, value * MediaQuery.of(context).size.height * 0.3),
            child: Opacity(
              opacity: 1 - value,
              child: child,
            ),
          );
      },
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            // Tab bar for switching between concerts and people in the overlay
            // Now positioned BEFORE the search bar
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
              child: Container(
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
            ),
            
            // Search Bar with Cancel button in same row
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {
                          _isTyping = value.isNotEmpty;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: _isSearchingConcerts 
                            ? 'Search for concerts' 
                            : 'Search for people',
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
                        // Perform search and close overlay
                        _performSearch(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isClosingOverlay = true;
                      });
                      
                      // Wait for animation to complete before fully closing
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (mounted) {
                          setState(() {
                            _showSearchOverlay = false;
                            _isTyping = false;
                            _isClosingOverlay = false;
                            _searchController.clear();
                          });
                        }
                      });
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
            
            // Location Bar (only for concerts tab)
            AnimatedSize(
              duration: const Duration(milliseconds: 150),
              alignment: Alignment.topCenter, // Align to top to prevent pushing content down
              curve: Curves.easeOutQuad,
              child: _isSearchingConcerts
                ? Padding(
                    key: const ValueKey('location-bar'),
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                    child: Container(
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
                          Expanded(
                            child: TextField(
                              controller: _locationController,
                              decoration: const InputDecoration(
                                hintText: 'Enter location',
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('no-location-bar')),
            ),
            
            // Header for list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    headerText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!_isTyping)
                    TextButton(
                      onPressed: () {
                        // Clear all recent searches for current tab
                        setState(() {
                          if (_isSearchingConcerts) {
                            // In a real app, you would clear from storage
                          } else {
                            // In a real app, you would clear from storage
                          }
                        });
                      },
                      child: const Text('Clear All'),
                    ),
                ],
              ),
            ),
            
            // List of recent searches or autocomplete suggestions
            Expanded(
              child: ListView.builder(
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  final item = displayList[index];
                  return ListTile(
                    leading: Icon(
                      _isTyping ? Icons.search : Icons.history,
                      color: Colors.grey,
                    ),
                    title: Text(item),
                    onTap: () {
                      _searchController.text = item;
                      _performSearch(item);
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

  // Filter autocomplete suggestions based on input
  List<String> _filterAutocompleteSuggestions(List<String> suggestions) {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      return suggestions;
    }
    return suggestions.where(
      (suggestion) => suggestion.toLowerCase().contains(query)
    ).toList();
  }

  // Perform search action
  void _performSearch(String value) {
    if (value.isEmpty) return;
    
    setState(() {
      _showSearchOverlay = false;
      _isTyping = false;
      
      // Add to recent searches if not already there
      if (_isSearchingConcerts) {
        if (!_recentConcertSearches.contains(value)) {
          // In a real app, you would update persistent storage here
        }
      } else {
        if (!_recentPeopleSearches.contains(value)) {
          // In a real app, you would update persistent storage here
        }
      }
    });
    
    // Here you would perform the actual search
    // and update UI accordingly
  }

  // Build the concert discovery section
  Widget _buildConcertDiscovery() {
    // Concert categories
    final List<Map<String, dynamic>> categories = [
      {
        'title': 'Raves',
        'subtitle': 'Electronic dance music',
        'icon': Icons.music_note,
        'color': Colors.purple.shade100,
      },
      {
        'title': 'Small Venues',
        'subtitle': 'Intimate performances',
        'icon': Icons.home,
        'color': Colors.blue.shade100,
      },
      {
        'title': 'Trending',
        'subtitle': 'Popular this week',
        'icon': Icons.trending_up,
        'color': Colors.orange.shade100,
      },
      {
        'title': 'Friend Recommendations',
        'subtitle': 'Events your friends like',
        'icon': Icons.people,
        'color': Colors.green.shade100,
      },
      {
        'title': 'Upcoming',
        'subtitle': 'Events this month',
        'icon': Icons.event,
        'color': Colors.red.shade100,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          child: Text(
            'Discover Concerts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    // Handle category tap
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          category['color'],
                          category['color'].withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          category['icon'],
                          size: 24,
                          color: Colors.black54,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                category['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                category['subtitle'],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Build the people discovery section
  Widget _buildPeopleDiscovery() {
    // Mock user data
    final List<Map<String, dynamic>> suggestedUsers = [
      {
        'name': 'Emma Thompson',
        'username': '@emma_t',
        'userId': 'user1',
      },
      {
        'name': 'Jacob Wilson',
        'username': '@j_wilson',
        'userId': 'user2',
      },
      {
        'name': 'Olivia Parker',
        'username': '@olivia_p',
        'userId': 'user3',
      },
      {
        'name': 'Noah Rodriguez',
        'username': '@noah_r',
        'userId': 'user4',
      },
      {
        'name': 'Sophia Chen',
        'username': '@sophia',
        'userId': 'user5',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          child: Text(
            'Discover People',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: suggestedUsers.length,
            itemBuilder: (context, index) {
              final user = suggestedUsers[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      ClickableUserAvatar(
                        userId: user['userId'],
                        radius: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Show user profile when tapped
                            UserProfileOverlay.show(context, user['userId']);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                user['username'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Follow user action
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppConstants.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: const Text('Follow'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_showSearchOverlay) {
          setState(() {
            _isClosingOverlay = true;
          });
          
          // Wait for animation to complete before handling back press
          await Future.delayed(const Duration(milliseconds: 300));
          if (mounted) {
            setState(() {
              _showSearchOverlay = false;
              _isTyping = false;
              _isClosingOverlay = false;
              _searchController.clear();
            });
          }
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // Base search screen (always visible)
              Column(
                children: [
                  // Header with logo and search bar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Logo placeholder
                        Row(
                          children: const [
                            Text(
                              'LOGO',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Tab bar for switching between concerts and people
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
                              _showSearchOverlay = true;
                            });
                          },
                          child: Container(
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
                                const Icon(Icons.search, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  _isSearchingConcerts 
                                      ? 'Search for concerts'
                                      : 'Search for people',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Location Bar (only for concerts tab)
                        AnimatedSize(
                          duration: const Duration(milliseconds: 150),
                          alignment: Alignment.topCenter, // Align to top to prevent pushing content down
                          curve: Curves.easeOutQuad,
                          child: _isSearchingConcerts
                            ? Container(
                                key: const ValueKey('location-bar'),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? AppConstants.darkGreyColor
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 20, color: Colors.grey),
                                    const SizedBox(width: 8),
                                    const Text('Your Location'),
                                    const Spacer(),
                                    Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink(key: ValueKey('no-location-bar')),
                        ),
                      ],
                    ),
                  ),
                  
                  // Content Section
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildConcertDiscovery(),
                        _buildPeopleDiscovery(),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Search overlay (conditionally visible)
              if (_showSearchOverlay)
                _buildSearchOverlay(),
            ],
          ),
        ),
      ),
    );
  }
}
