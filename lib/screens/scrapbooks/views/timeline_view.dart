import 'package:flutter/material.dart';
import '../../../models/memories/index.dart';
import '../utils/media_formatters.dart';
import '../utils/media_builders.dart';

class TimelineView extends StatefulWidget {
  final List<ScrapbookMedia> mediaItems;
  final Function(ScrapbookMedia) onMediaTap;

  const TimelineView({
    Key? key,
    required this.mediaItems,
    required this.onMediaTap,
  }) : super(key: key);

  @override
  State<TimelineView> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isAnnotationVisible = false;
  Map<String, String> _mediaTitles = {}; // Store custom titles for timestamps
  
  // For vertical drag of pull tab
  double _pullTabTopPosition = 70.0;

  // This initState is replaced by the new one

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleAnnotation() {
    if (_isAnnotationVisible) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      _isAnnotationVisible = !_isAnnotationVisible;
    });
  }

  void _addMediaTitle(ScrapbookMedia media) {
    final key = media.id;
    showDialog(
      context: context,
      builder: (context) {
        String title = _mediaTitles[key] ?? '';
        return AlertDialog(
          title: const Text('Add Title'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter title for this moment'),
            onChanged: (value) {
              title = value;
            },
            controller: TextEditingController(text: title),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                setState(() {
                  _mediaTitles[key] = title;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Keep state when switching tabs
  @override
  bool get wantKeepAlive => true;
  
  // Track current visible media for timeline dot highlighting
  int _currentVisibleMediaIndex = 0;
  ScrollController _scrollController = ScrollController();
  
  void _showAddTimestampDialog() {
    final now = DateTime.now();
    showDialog(
      context: context,
      builder: (context) {
        DateTime selectedTime = now;
        return AlertDialog(
          title: const Text('Add Timestamp'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select time:'),
              SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(selectedTime),
                  );
                  if (time != null) {
                    selectedTime = DateTime(
                      selectedTime.year,
                      selectedTime.month,
                      selectedTime.day,
                      time.hour,
                      time.minute,
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(MediaFormatters.formatTimestamp(selectedTime)),
                      Icon(Icons.access_time),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                // Here you would actually add a new media item with this timestamp
                // For now, just show a confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added timestamp: ${MediaFormatters.formatTimestamp(selectedTime)}')),
                );
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _scrollController.addListener(() {
      // Update current visible media index based on scroll position
      // This is a simple implementation that can be refined for more accuracy
      final itemHeight = MediaQuery.of(context).size.width * 9 / 16 + 2; // Assuming 16:9 aspect ratio + 2px margin
      final currentIndex = (_scrollController.offset / itemHeight).floor();
      
      if (currentIndex != _currentVisibleMediaIndex && 
          currentIndex >= 0 && 
          currentIndex < widget.mediaItems.length) {
        setState(() {
          _currentVisibleMediaIndex = currentIndex;
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    if (widget.mediaItems.isEmpty) {
      return const Center(child: Text('No media added yet. Tap + to add memories.'));
    }

    // Sort media by timestamp
    final sortedMedia = List<ScrapbookMedia>.from(widget.mediaItems)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return Stack(
      children: [
        // Main content - vertically scrolling photos
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: sortedMedia.map((media) {
              return GestureDetector(
                onTap: () => widget.onMediaTap(media),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 0), // No gap between photos
                  child: Stack(
                    children: [
                      // Media content
                      MediaBuilders.buildMediaContent(context, media),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        
        // Timeline rail with dots (only visible when sidebar is closed)
        if (!_isAnnotationVisible)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 30,
              child: Stack(
                children: [
                  // Background rail
                  Container(
                    width: 2,
                    height: double.infinity,
                    color: Colors.grey.withOpacity(0.3),
                    margin: EdgeInsets.only(left: 14),
                  ),
                  
                  // Timeline dots
                  ...List.generate(sortedMedia.length, (index) {
                    final media = sortedMedia[index];
                    final isCurrentMedia = index == _currentVisibleMediaIndex;
                    
                    // Calculate approximate position based on media index
                    // This is a simplified approach and could be refined
                    final itemHeight = MediaQuery.of(context).size.width * 9 / 16 + 2;
                    final topPosition = itemHeight * index;
                    
                    return Positioned(
                      top: topPosition + (itemHeight / 2) - 5, // Center dot vertically on media
                      left: 10,
                      child: GestureDetector(
                        onTap: () {
                          // Scroll to this media item
                          _scrollController.animateTo(
                            topPosition,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCurrentMedia ? Colors.blue : Colors.grey.withOpacity(0.7),
                            border: isCurrentMedia 
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        
        // Pull tab for timeline (always visible)
        Positioned(
          left: _isAnnotationVisible ? 250 : 0, // Tab moves with the panel
          top: _pullTabTopPosition, // Position can be changed by dragging
          child: GestureDetector(
            onTap: _toggleAnnotation,
            onVerticalDragUpdate: (details) {
              // Allow vertical dragging of the tab
              setState(() {
                _pullTabTopPosition += details.delta.dy;
                // Constrain the position to be within the screen bounds
                _pullTabTopPosition = _pullTabTopPosition.clamp(
                  70.0, // Min position (below app bar)
                  MediaQuery.of(context).size.height - 120.0, // Max position (above bottom)
                );
              });
            },
            onHorizontalDragUpdate: (details) {
              if (details.primaryDelta! > 0 && !_isAnnotationVisible) {
                _toggleAnnotation();
              } else if (details.primaryDelta! < 0 && _isAnnotationVisible) {
                _toggleAnnotation();
              }
            },
            child: Container(
              width: 30,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.8),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Icon(
                _isAnnotationVisible ? Icons.chevron_left : Icons.chevron_right,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        
        // Slide-in annotations panel
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Positioned(
              left: -250 * (1 - _animation.value),
              top: 0,
              bottom: 0,
              child: Container(
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  boxShadow: _isAnnotationVisible ? [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(3, 0),
                    ),
                  ] : [],
                ),
                child: Stack(
                  children: [
                    // Annotations list
                    ListView.builder(
                      padding: const EdgeInsets.only(top: 20, bottom: 70, left: 10, right: 10),
                      itemCount: sortedMedia.length,
                      itemBuilder: (context, index) {
                        final media = sortedMedia[index];
                        final isCurrentMedia = index == _currentVisibleMediaIndex;
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Show date header if this is a new day
                            if (index == 0 || 
                                !MediaFormatters.isSameDay(media.timestamp, sortedMedia[index - 1].timestamp))
                              Padding(
                                padding: const EdgeInsets.only(top: 16, bottom: 8),
                                child: Text(
                                  MediaFormatters.formatDate(media.timestamp),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            
                            // Timestamp and title option
                            InkWell(
                              onTap: () => _addMediaTitle(media),
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isCurrentMedia ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isCurrentMedia ? Colors.blue : Colors.transparent,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      MediaFormatters.formatTimestamp(media.timestamp),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: isCurrentMedia ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                    if (_mediaTitles.containsKey(media.id))
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          _mediaTitles[media.id]!,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    
                    // Add timestamp button
                    Positioned(
                      right: 20,
                      bottom: 20,
                      child: FloatingActionButton(
                        mini: true,
                        onPressed: _showAddTimestampDialog,
                        heroTag: 'add_timestamp_button', // Unique hero tag
                        child: const Icon(Icons.add),
                        tooltip: 'Add Timestamp',
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
