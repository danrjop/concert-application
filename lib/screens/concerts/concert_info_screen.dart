import 'package:flutter/material.dart';
import '../../models/concert.dart';
import '../../constants/app_constants.dart';

class ConcertInfoScreen extends StatefulWidget {
  final Concert? concert;
  final String? source; // Indicates where user came from (e.g., 'been', 'want_to_go', 'trending', 'feed')
  
  const ConcertInfoScreen({
    Key? key,
    this.concert,
    this.source,
  }) : super(key: key);

  @override
  State<ConcertInfoScreen> createState() => _ConcertInfoScreenState();
}

class _ConcertInfoScreenState extends State<ConcertInfoScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Concert concertData;
  bool _isFavorite = false;
  
  // List of tab labels
  final List<String> _tabs = ['Details', 'Setlist', 'Photos', 'Reviews'];
  
  @override
  void initState() {
    super.initState();
    // Initialize with the passed concert or a dummy one for preview
    concertData = widget.concert ?? Concert.dummy();
    
    // Set default favorite status (could be retrieved from a service in a real app)
    _isFavorite = false;
    
    // Initialize tab controller
    _tabController = TabController(length: _tabs.length, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  // Format the date in a readable way
  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
  
  // Format the time in a readable way
  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '${hour == 0 ? 12 : hour}:${date.minute.toString().padLeft(2, '0')} $period';
  }
  
  // Add to 'Been' section
  void _markAsAttended() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${concertData.name} to your Been list'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Removed ${concertData.name} from your Been list'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }
  
  // Add to 'Want to go' section
  void _addToWantToGo() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${concertData.name} to your Want to Go list'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Removed ${concertData.name} from your Want to Go list'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }
  
  // Buy tickets
  void _buyTickets() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Finding tickets for ${concertData.name}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  // Toggle favorite status
  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    
    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite 
          ? 'Added to favorites' 
          : 'Removed from favorites'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _isFavorite = !_isFavorite;
            });
          },
        ),
      ),
    );
  }
  
  // Share concert information
  void _shareConcert() {
    // This would implement actual sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing concert information...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            // Sliver app bar with concert image and details
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Concert image (would be a real image in production)
                    Container(
                      color: Colors.black,
                      child: Opacity(
                        opacity: 0.7,
                        child: Image.network(
                          'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80',
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.music_note, size: 64, color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Gradient overlay for better text visibility
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    // Action buttons positioned at bottom right of the header
                    Positioned(
                      right: 16,
                      bottom: 16, // Position at the bottom right corner
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Been button
                          GestureDetector(
                            onTap: _markAsAttended,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(left: 8),
                              child: const Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          // Bookmark button
                          GestureDetector(
                            onTap: _addToWantToGo,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(left: 8),
                              child: const Icon(
                                Icons.bookmark_outline,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          // Ticket button
                          GestureDetector(
                            onTap: _buyTickets,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(left: 8),
                              child: const Icon(
                                Icons.confirmation_number_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Concert info overlay at the bottom
                    Positioned(
                      left: 16,
                      right: 80, // Make room for the action buttons on the right
                      bottom: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Concert name
                          Text(
                            concertData.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Artist names
                          Text(
                            concertData.artists.join(', '),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          // Date only (removed time to avoid overlap)
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.white.withOpacity(0.8),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatDate(concertData.date),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Venue
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white.withOpacity(0.8),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  concertData.venue,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // App bar actions
              actions: [
                // Favorite button
                IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: _toggleFavorite,
                ),
                // Share button
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.white),
                  onPressed: _shareConcert,
                ),
              ],
            ),
            // Tab bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: AppConstants.primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppConstants.primaryColor,
                  tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
                ),
                backgroundColor: Theme.of(context).cardColor,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Details tab - now includes the ratings, actions, and genres
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating and Actions section
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating display
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              final isHalf = index + 0.5 == concertData.rating.floorToDouble() + 0.5 && 
                                          index < concertData.rating;
                              final isFull = index < concertData.rating.floor();
                              
                              return Icon(
                                isHalf ? Icons.star_half : (isFull ? Icons.star : Icons.star_border),
                                color: Colors.amber,
                                size: 24,
                              );
                            }),
                            const SizedBox(width: 8),
                            Text(
                              concertData.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const Spacer(),
                            // Add Rating button (if needed)
                            TextButton.icon(
                              icon: const Icon(Icons.rate_review),
                              label: const Text('Rate'),
                              onPressed: () {
                                // Show rating dialog
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Scrapbooks section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Scrapbooks',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 160,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  // Create new scrapbook card
                                  Container(
                                    width: 120,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppConstants.primaryColor.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        // Create new scrapbook functionality
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Creating new scrapbook...'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_circle_outline,
                                            color: AppConstants.primaryColor,
                                            size: 36,
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            'Create New',
                                            style: TextStyle(
                                              color: AppConstants.primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Scrapbook',
                                            style: TextStyle(
                                              color: AppConstants.primaryColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  
                                  // Example existing scrapbooks
                                  _buildScrapbookItem('Summer Tour', '7 pages', Colors.blue[100]!),
                                  _buildScrapbookItem('My Memories', '3 pages', Colors.green[100]!),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Genres section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Genres',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: concertData.genres.map((genre) => Chip(
                            label: Text(genre),
                            backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
                            labelStyle: TextStyle(color: AppConstants.primaryColor),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                  
                  // Add the details content
                  _buildDetailsTab(),
                ],
              ),
            ),
            
            // Setlist tab
            _buildSetlistTab(),
            
            // Photos tab
            _buildPhotosTab(),
            
            // Reviews tab
            _buildReviewsTab(),
          ],
        ),
      ),
      // Removed the 'Want to Go' floating action button
    );
  }
  
  // Helper method to build a scrapbook item
  Widget _buildScrapbookItem(String title, String pages, Color color) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Open scrapbook functionality
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening $title scrapbook...'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: Stack(
          children: [
            // Decorative elements to make it look like a scrapbook
            Positioned(
              top: 8,
              right: 8,
              child: Icon(
                Icons.auto_stories,
                color: Colors.white.withOpacity(0.6),
                size: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Sample polaroid-style image
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Center(
                      child: Icon(
                        Icons.music_note,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Number of pages
                  Text(
                    pages,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Build the details tab content
  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About section
          const Text(
            'About',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This is a placeholder description for ${concertData.name}. In a real application, this would contain details about the concert experience, the venue, the performances, and other relevant information.',
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 24),
          
          // Artists section
          const Text(
            'Artists',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          ...concertData.artists.map((artist) => ListTile(
            leading: CircleAvatar(
              child: Text(artist[0], style: const TextStyle(color: Colors.white)),
              backgroundColor: AppConstants.primaryColor,
            ),
            title: Text(artist),
            subtitle: const Text('Performer'),
            contentPadding: EdgeInsets.zero,
            onTap: () {
              // Navigate to artist profile
            },
          )),
          const SizedBox(height: 24),
          
          // Venue information
          const Text(
            'Venue Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    concertData.venue,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '123 Main Street, City, State 12345',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.map),
                          label: const Text('View Map'),
                          onPressed: () {
                            // Open map view
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppConstants.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.directions),
                          label: const Text('Directions'),
                          onPressed: () {
                            // Get directions
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppConstants.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Weather information (if relevant for upcoming concert)
          if (concertData.date.isAfter(DateTime.now()))
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weather Forecast',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.wb_sunny, size: 48, color: Colors.orange),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '72°F / Sunny',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Forecast for ${_formatDate(concertData.date)}',
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Perfect concert weather!',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
  
  // Build the setlist tab content
  Widget _buildSetlistTab() {
    // Placeholder setlist data
    final setlistItems = []; // Empty the list to show the empty state with Add Setlist button
    
    return setlistItems.isEmpty
      ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.queue_music,
                size: 64,
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'No setlist added yet',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.playlist_add),
                label: const Text('Add Setlist'),
                onPressed: () {
                  // Add setlist functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Adding setlist...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
        )
      : Column(
          children: [
            // Add Setlist button at the top when not empty
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.playlist_add),
                  label: const Text('Add Songs'),
                  onPressed: () {
                    // Add more songs to setlist
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Adding songs to setlist...'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppConstants.primaryColor,
                  ),
                ),
              ),
            ),
            // Setlist items
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: setlistItems.length,
                itemBuilder: (context, index) {
                  final item = setlistItems[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
                      child: Text(
                        '${index + 1}', 
                        style: TextStyle(color: AppConstants.primaryColor),
                      ),
                    ),
                    title: Text(item['title']!),
                    subtitle: Text('Duration: ${item['duration']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {
                        // Favorite song functionality
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
  }
  
  // Build the photos tab content
  Widget _buildPhotosTab() {
    // Placeholder photo URLs (would be real images in production)
    final photoUrls = [
      'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?w=300&h=300&fit=crop',
      'https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?w=300&h=300&fit=crop',
      'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=300&h=300&fit=crop',
      'https://images.unsplash.com/photo-1563841930606-67e2bce48b78?w=300&h=300&fit=crop',
      'https://images.unsplash.com/photo-1524368535928-5b5e00ddc76b?w=300&h=300&fit=crop',
      'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop',
      'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=300&h=300&fit=crop',
      'https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=300&h=300&fit=crop',
      'https://images.unsplash.com/photo-1429962714451-bb934ecdc4ec?w=300&h=300&fit=crop',
    ];
    
    return photoUrls.isEmpty
      ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_library,
                size: 64,
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'No photos added yet',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Add photos functionality
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppConstants.primaryColor,
                ),
                child: const Text('Add Photos'),
              ),
            ],
          ),
        )
      : GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: photoUrls.length + 1, // +1 for the add photo button
          itemBuilder: (context, index) {
            // Add photo button as the first item
            if (index == 0) {
              return InkWell(
                onTap: () {
                  // Handle add photo functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Adding photos...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppConstants.primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        color: AppConstants.primaryColor,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add Photos',
                        style: TextStyle(
                          color: AppConstants.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            
            // Display photos with adjusted index
            return InkWell(
              onTap: () {
                // Open photo viewer
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  photoUrls[index - 1], // Adjust index for the photos
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
  }
  
  // Build the reviews tab content
  Widget _buildReviewsTab() {
    // Placeholder friend review data
    final friendReviewItems = [
      {
        'username': 'BestFriend42',
        'isFriend': true,
        'rating': 4.8,
        'date': '1 day ago',
        'text': 'Had an amazing time! The acoustics were perfect and the energy was incredible. Definitely recommend seeing this artist live.'
      },
      {
        'username': 'MusicBuddy',
        'isFriend': true,
        'rating': 4.5,
        'date': '3 days ago',
        'text': 'Great show! We were in the front row and the sound was fantastic. The opening act was also surprisingly good.'
      },
    ];
    
    // Placeholder other users review data
    final otherReviewItems = [
      {
        'username': 'ConcertGoer456',
        'isFriend': false,
        'rating': 5.0,
        'date': '1 week ago',
        'text': 'Best show I\'ve been to this year. Every song was perfect and the crowd was so into it.'
      },
      {
        'username': 'MusicLover789',
        'isFriend': false,
        'rating': 3.5,
        'date': '2 weeks ago',
        'text': 'Good performance but the venue was too crowded. Sound quality was great though.'
      },
      {
        'username': 'ConcertFan20',
        'isFriend': false,
        'rating': 4.0,
        'date': '3 weeks ago',
        'text': 'Really enjoyed the concert. The artist had great stage presence and the setlist was well planned.'
      },
    ];
    
    final allReviewsEmpty = friendReviewItems.isEmpty && otherReviewItems.isEmpty;
    
    return allReviewsEmpty
      ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.rate_review,
                size: 64,
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'No reviews yet',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Add review functionality
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppConstants.primaryColor,
                ),
                child: const Text('Write a Review'),
              ),
            ],
          ),
        )
      : ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Write a review button at the top
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Add review functionality
                },
                icon: const Icon(Icons.rate_review),
                label: const Text('Write a Review'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppConstants.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Friend reviews section
            if (friendReviewItems.isNotEmpty) ...[              
              const Text(
                'Friend Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...friendReviewItems.map((review) => _buildReviewCard(review, true)),
              const SizedBox(height: 24),
            ],
            
            // Other reviews section
            if (otherReviewItems.isNotEmpty) ...[              
              const Text(
                'Other Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...otherReviewItems.map((review) => _buildReviewCard(review, false)),
            ],
          ],
        );
  }
  
  // Helper method to build review cards
  Widget _buildReviewCard(Map<String, dynamic> review, bool isFriend) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isFriend 
            ? BorderSide(color: AppConstants.primaryColor.withOpacity(0.3), width: 1.5)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // User avatar
                CircleAvatar(
                  backgroundColor: isFriend 
                      ? AppConstants.primaryColor.withOpacity(0.2)
                      : Colors.grey[300],
                  child: Text(
                    (review['username'] as String)[0].toUpperCase(),
                    style: TextStyle(
                      color: isFriend ? AppConstants.primaryColor : Colors.black54,
                      fontWeight: isFriend ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  radius: 20,
                ),
                const SizedBox(width: 12),
                // User name and date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review['username']! as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (isFriend) ...[  
                          const SizedBox(width: 4),
                          Icon(
                            Icons.people,
                            size: 14,
                            color: AppConstants.primaryColor,
                          ),
                        ],
                      ],
                    ),
                    Text(
                      review['date']! as String,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Rating
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      (review['rating'] as double).toStringAsFixed(1),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Review text
            Text(
              review['text']! as String,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 12),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.thumb_up_outlined, size: 18),
                  label: const Text('Helpful'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () {},
                ),
                TextButton.icon(
                  icon: const Icon(Icons.comment_outlined, size: 18),
                  label: const Text('Reply'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// Custom delegate for the sliver persistent header to show the tab bar
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;

  _SliverTabBarDelegate(this.tabBar, {required this.backgroundColor});

  @override
  double get minExtent => tabBar.preferredSize.height;
  
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar || backgroundColor != oldDelegate.backgroundColor;
  }
}
