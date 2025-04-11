import 'package:flutter/material.dart';
import '../../models/memories/index.dart';
import '../../constants/app_constants.dart';
import 'views/index.dart';
import 'utils/index.dart';

/// Scrapbook detail screen - displays media content in different organizational views
/// 
/// THEMATIC VISION:
/// This feature aims to transform how concert-goers preserve and share memories by:
/// 1. Creating a hybrid timeline/thematic experience that intelligently groups content
///    based on both chronology and subject matter (friends, venue, performances)
/// 2. Supporting multiple media types (photos, videos, audio, text) to capture the 
///    full sensory experience of a concert
/// 3. Making sharing to social media seamless with auto-generated, visually appealing
///    content optimized for platforms like Instagram and TikTok
/// 4. Enabling collaborative scrapbooks where friends can contribute their own media
///    to create a shared memory of the event
/// 
/// The UI is designed to be visually rich with customizable templates that match 
/// music genres and vibes while maintaining usability for quick capture and sharing
/// during or immediately after concerts.
///
/// Status: INCOMPLETE - Implementation in progress
/// Future work: Backend integration, media playback, actual sharing integration
class ScrapbookDetailScreen extends StatefulWidget {
  final ScrapbookItem scrapbook;
  final String? source;

  const ScrapbookDetailScreen({
    Key? key,
    required this.scrapbook,
    this.source,
  }) : super(key: key);

  @override
  State<ScrapbookDetailScreen> createState() => _ScrapbookDetailScreenState();
}

class _ScrapbookDetailScreenState extends State<ScrapbookDetailScreen> with TickerProviderStateMixin {
  // View mode, editing state and template options
  String _currentView = 'timeline'; // 'timeline', 'highlights', 'grid'
  bool _isEditing = false;
  String _selectedTheme = 'Auto';
  String _selectedTemplate = 'Classic';
  final List<String> _templates = ['Classic', 'Modern', 'Vintage', 'Festival', 'Rock', 'Pop', 'EDM'];
  
  // Tab controller for view modes
  late TabController _viewTabController;
  
  // Placeholder for scrapbook media elements
  List<ScrapbookMedia> _scrapbookMedia = [];

  @override
  void initState() {
    super.initState();
    _viewTabController = TabController(length: 3, vsync: this);
    _loadScrapbookMedia();
  }

  @override
  void dispose() {
    _viewTabController.dispose();
    super.dispose();
  }

  /// Loads mock media content - will be replaced with Supabase integration
  void _loadScrapbookMedia() {
    // Mock data loading - in real implementation, fetch from Supabase
    setState(() {
      _scrapbookMedia = [
        // Just a couple of examples - full implementation has more
        ScrapbookMedia(
          id: '1',
          type: 'photo',
          url: 'assets/images/concert1.jpg',
          caption: 'On our way to the venue!',
          timestamp: DateTime(2023, 8, 15, 18, 30),
          tags: ['pre-show', 'friends', 'excitement'],
          section: 'pre-show',
        ),
        ScrapbookMedia(
          id: '7',
          type: 'video',
          url: 'assets/videos/favorite_song.mp4',
          caption: 'They played my favorite song!',
          timestamp: DateTime(2023, 8, 15, 21, 45),
          tags: ['performance', 'favorite', 'highlight'],
          section: 'main-show',
          duration: const Duration(minutes: 1, seconds: 20),
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scrapbook.title),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          // Template button
          IconButton(
            icon: const Icon(Icons.style),
            tooltip: 'Change Template',
            onPressed: _showTemplateDialog,
          ),
          // Share button
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share Scrapbook',
            onPressed: _showShareOptions,
          ),
          // Edit toggle
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            tooltip: _isEditing ? 'Save Changes' : 'Edit Scrapbook',
            onPressed: () {
              setState(() { _isEditing = !_isEditing; });
            },
          ),
        ],
        bottom: TabBar(
          controller: _viewTabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          onTap: (index) {
            setState(() {
              _currentView = index == 0 ? 'timeline' : (index == 1 ? 'highlights' : 'grid');
            });
          },
          tabs: const [
            Tab(icon: Icon(Icons.timeline), text: 'Timeline'),
            Tab(icon: Icon(Icons.auto_awesome), text: 'Highlights'),
            Tab(icon: Icon(Icons.grid_on), text: 'Grid'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _viewTabController,
        children: [
          // Timeline view - chronological order with swipeable annotations
          TimelineView(
            mediaItems: _scrapbookMedia, 
            onMediaTap: _showMediaDetail,
          ),
          
          // Highlights view - grouped by themes across different times
          ThematicView(
            mediaItems: _scrapbookMedia, 
            onMediaTap: _showMediaDetail,
          ),
          
          // Grid view - manageable gallery for adding/removing media
          GridMediaView(
            mediaItems: _scrapbookMedia, 
            onMediaTap: _showMediaDetail,
          ),
        ],
      ),
      floatingActionButton: _isEditing ? FloatingActionButton(
        onPressed: _showAddMediaSheet,
        backgroundColor: AppConstants.primaryColor,
        child: const Icon(Icons.add),
      ) : null,
    );
  }

  /// Shows the template selection dialog
  void _showTemplateDialog() {
    MediaDialogs.showTemplateDialog(
      context,
      _selectedTheme,
      _selectedTemplate,
      _templates,
      (newTheme) {
        setState(() {
          _selectedTheme = newTheme;
        });
      },
      (newTemplate) {
        setState(() {
          _selectedTemplate = newTemplate;
        });
        _applyTemplate();
      },
    );
  }
  
  /// Apply the selected template
  void _applyTemplate() {
    // In a real app, this would update the visual style of the scrapbook
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Template updated to $_selectedTemplate')),
    );
  }

  /// Shows the share options
  void _showShareOptions() {
    MediaDialogs.showShareOptions(context, widget.scrapbook.title);
  }

  /// Shows media addition options
  void _showAddMediaSheet() {
    MediaDialogs.showAddMediaSheet(context, _addMedia);
  }
  
  /// Handle adding media of a specific type
  void _addMedia(String type, bool capture) {
    // Mock implementation - in a real app, this would use camera/media plugins
    setState(() {
      final newId = 'media_${DateTime.now().millisecondsSinceEpoch}';
      final now = DateTime.now();
      
      ScrapbookMedia newMedia;
      
      switch (type) {
        case 'photo':
          newMedia = ScrapbookMedia(
            id: newId,
            type: 'photo',
            url: 'assets/images/concert_placeholder.jpg',
            caption: capture ? 'Photo taken now' : 'Photo from gallery',
            timestamp: now,
            tags: ['new', type],
            section: 'main-show',
          );
          break;
        case 'video':
          newMedia = ScrapbookMedia(
            id: newId,
            type: 'video',
            url: 'assets/videos/video_placeholder.mp4',
            caption: capture ? 'Video recorded now' : 'Video from library',
            timestamp: now,
            tags: ['new', type],
            section: 'main-show',
            duration: const Duration(minutes: 1, seconds: 30),
          );
          break;
        case 'audio':
          newMedia = ScrapbookMedia(
            id: newId,
            type: 'audio',
            url: 'assets/audio/audio_placeholder.mp3',
            caption: 'Audio recording',
            timestamp: now,
            tags: ['new', type],
            section: 'main-show',
            duration: const Duration(minutes: 2, seconds: 15),
          );
          break;
        case 'text':
          // For text, we'd normally show a text input dialog
          // For now, just add a dummy text note
          newMedia = ScrapbookMedia(
            id: newId,
            type: 'text',
            content: 'This was such an amazing concert! The energy was incredible, and the crowd was so into it. Definitely one of the best shows I\'ve seen this year.',
            caption: 'My thoughts',
            timestamp: now,
            tags: ['new', 'thoughts', 'review'],
            section: 'post-show',
          );
          break;
        default:
          // For other types, show a placeholder message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$type media type not fully implemented yet')),
          );
          return;
      }
      
      _scrapbookMedia.add(newMedia);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New media added to scrapbook')),
    );
  }

  /// Show media detail in fullscreen or modal
  void _showMediaDetail(ScrapbookMedia media) {
    MediaDialogs.showMediaDetail(
      context,
      media,
      _isEditing,
      () => _showShareOptions(),
      _isEditing ? () {
        // Would show edit dialog in a real app
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edit functionality not implemented yet')),
        );
      } : null,
      _isEditing ? () {
        // Would show delete confirmation in a real app
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Delete functionality not implemented yet')),
        );
      } : null,
    );
  }
}
