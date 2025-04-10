import 'package:flutter/material.dart';
import '../../models/memories/index.dart';
import '../../constants/app_constants.dart';
import '../../utils/share_utils.dart';

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
  String _currentView = 'timeline'; // 'timeline', 'thematic', 'grid'
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
              _currentView = index == 0 ? 'timeline' : (index == 1 ? 'thematic' : 'grid');
            });
          },
          tabs: const [
            Tab(icon: Icon(Icons.timeline), text: 'Timeline'),
            Tab(icon: Icon(Icons.category), text: 'Themes'),
            Tab(icon: Icon(Icons.grid_on), text: 'Grid'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _viewTabController,
        children: [
          // Timeline view - chronological order
          _buildTimelineView(),
          
          // Thematic view - grouped by theme
          _buildThematicView(),
          
          // Grid view - simple gallery style
          _buildGridView(),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Template'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Theme'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedTheme,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: 'Auto', child: Text('Auto (Match Genre)')),
                DropdownMenuItem(value: 'Light', child: Text('Light')),
                DropdownMenuItem(value: 'Dark', child: Text('Dark')),
                DropdownMenuItem(value: 'Vibrant', child: Text('Vibrant')),
              ],
              onChanged: (newValue) {
                setState(() {
                  _selectedTheme = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text('Template'),
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _templates.length,
                itemBuilder: (context, index) {
                  final template = _templates[index];
                  final isSelected = template == _selectedTemplate;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTemplate = template;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? AppConstants.primaryColor : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getTemplateIcon(template),
                            color: isSelected ? AppConstants.primaryColor : Colors.grey[600],
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            template,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? AppConstants.primaryColor : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Template updated to $_selectedTemplate')),
              );
            },
            child: const Text('APPLY'),
          ),
        ],
      ),
    );
  }
  
  /// Get icon for template
  IconData _getTemplateIcon(String template) {
    switch (template) {
      case 'Classic':
        return Icons.photo_album;
      case 'Modern':
        return Icons.grid_view;
      case 'Vintage':
        return Icons.camera_alt;
      case 'Festival':
        return Icons.festival;
      case 'Rock':
        return Icons.music_note;
      case 'Pop':
        return Icons.star;
      case 'EDM':
        return Icons.waves;
      default:
        return Icons.style;
    }
  }

  /// Shows the share options
  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            title: Text(
              'Share Scrapbook',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.messenger_outline),
            title: const Text('Message'),
            onTap: () {
              Navigator.pop(context);
              ShareUtils.shareAsMessage(
                context,
                'Check out my ${widget.scrapbook.title} concert scrapbook!',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Instagram Story'),
            onTap: () {
              Navigator.pop(context);
              ShareUtils.shareToInstagram(
                context,
                'Preparing Instagram story for ${widget.scrapbook.title}...',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.video_collection),
            title: const Text('TikTok'),
            onTap: () {
              Navigator.pop(context);
              ShareUtils.shareToTikTok(
                context,
                'Preparing TikTok video for ${widget.scrapbook.title}...',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.qr_code),
            title: const Text('QR Code'),
            onTap: () {
              Navigator.pop(context);
              ShareUtils.shareQRCode(
                context,
                'Generating QR code for ${widget.scrapbook.title}...',
              );
            },
          ),
        ],
      ),
    );
  }


  /// Shows media addition options
  void _showAddMediaSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            title: Text(
              'Add to Scrapbook',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              _buildAddMediaOption(
                icon: Icons.photo_camera,
                label: 'Take Photo',
                onTap: () => _addMedia('photo', true),
              ),
              _buildAddMediaOption(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: () => _addMedia('photo', false),
              ),
              _buildAddMediaOption(
                icon: Icons.videocam,
                label: 'Record Video',
                onTap: () => _addMedia('video', true),
              ),
              _buildAddMediaOption(
                icon: Icons.video_library,
                label: 'Video Library',
                onTap: () => _addMedia('video', false),
              ),
              _buildAddMediaOption(
                icon: Icons.mic,
                label: 'Record Audio',
                onTap: () => _addMedia('audio', true),
              ),
              _buildAddMediaOption(
                icon: Icons.text_snippet,
                label: 'Text Note',
                onTap: () => _addMedia('text', false),
              ),
              _buildAddMediaOption(
                icon: Icons.note_add,
                label: 'Setlist',
                onTap: () => _addMedia('setlist', false),
              ),
              _buildAddMediaOption(
                icon: Icons.location_on,
                label: 'Venue Info',
                onTap: () => _addMedia('location', false),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
  
  /// Build an add media option button
  Widget _buildAddMediaOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppConstants.primaryColor),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
  
  /// Handle adding media of a specific type
  void _addMedia(String type, bool capture) {
    Navigator.pop(context); // Close the sheet
    
    // Mock implementation - in a real app, this would use camera/media plugins
    // For now, we'll create a dummy media item
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

  /// Build the timeline view (chronological)
  Widget _buildTimelineView() {
    if (_scrapbookMedia.isEmpty) {
      return const Center(child: Text('No media added yet. Tap + to add memories.'));
    }
    
    // Sort media by timestamp
    final sortedMedia = List<ScrapbookMedia>.from(_scrapbookMedia)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedMedia.length,
      itemBuilder: (context, index) {
        final media = sortedMedia[index];
        final bool showDate = index == 0 || 
          !_isSameDay(media.timestamp, sortedMedia[index - 1].timestamp);
          
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show date header if this is a new day
            if (showDate)
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  _formatDate(media.timestamp),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              
            // Media card with timestamp
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Media content
                  _buildMediaContent(media),
                  
                  // Caption and metadata
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (media.caption != null) 
                          Text(
                            media.caption!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          _formatTimestamp(media.timestamp),
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        if (media.tags.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Wrap(
                              spacing: 6,
                              children: media.tags.map((tag) => Chip(
                                label: Text(
                                  '#$tag',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                padding: EdgeInsets.zero,
                                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                              )).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
  
  /// Build the thematic view (grouped by tags)
  Widget _buildThematicView() {
    if (_scrapbookMedia.isEmpty) {
      return const Center(child: Text('No media added yet. Tap + to add memories.'));
    }
    
    // Group media by section (pre-show, main-show, post-show)
    final Map<String, List<ScrapbookMedia>> mediaBySection = {};
    
    for (final media in _scrapbookMedia) {
      if (!mediaBySection.containsKey(media.section)) {
        mediaBySection[media.section] = [];
      }
      mediaBySection[media.section]!.add(media);
    }
    
    // Get all sections and sort them in logical order
    final List<String> sections = mediaBySection.keys.toList();
    sections.sort((a, b) {
      final order = {'pre-show': 0, 'main-show': 1, 'post-show': 2};
      return (order[a] ?? 99).compareTo(order[b] ?? 99);
    });
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        final sectionMedia = mediaBySection[section]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Padding(
              padding: const EdgeInsets.only(bottom: 16, top: 16),
              child: Text(
                _formatSectionName(section),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Grid of media for this section
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: sectionMedia.length,
              itemBuilder: (context, mediaIndex) {
                final media = sectionMedia[mediaIndex];
                return GestureDetector(
                  onTap: () => _showMediaDetail(media),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildMediaThumbnail(media),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
  
  /// Build the grid view (gallery style)
  Widget _buildGridView() {
    if (_scrapbookMedia.isEmpty) {
      return const Center(child: Text('No media added yet. Tap + to add memories.'));
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: _scrapbookMedia.length,
      itemBuilder: (context, index) {
        final media = _scrapbookMedia[index];
        return GestureDetector(
          onTap: () => _showMediaDetail(media),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildMediaThumbnail(media),
              
              // Type indicator icon
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getMediaTypeIcon(media.type),
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Format date to display in timeline
  String _formatDate(DateTime dateTime) {
    return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
  }
  
  /// Format timestamp for display
  String _formatTimestamp(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
  
  /// Format media duration
  String _formatDuration(Duration? duration) {
    if (duration == null) return '';
    
    final minutes = duration.inMinutes;
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
  
  /// Check if two dates are the same day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
  
  /// Format section name for display
  String _formatSectionName(String section) {
    switch (section) {
      case 'pre-show':
        return 'Before the Show';
      case 'main-show':
        return 'During the Show';
      case 'post-show':
        return 'After the Show';
      default:
        return section.split('-').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
    }
  }
  
  /// Build media content based on type
  Widget _buildMediaContent(ScrapbookMedia media) {
    switch (media.type) {
      case 'photo':
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: _buildPhotoContent(media),
        );
      case 'video':
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: _buildVideoContent(media),
        );
      case 'audio':
        return _buildAudioContent(media);
      case 'text':
        return _buildTextContent(media);
      default:
        return const SizedBox.shrink();
    }
  }
  
  /// Build media thumbnail
  Widget _buildMediaThumbnail(ScrapbookMedia media) {
    switch (media.type) {
      case 'photo':
        return _buildPhotoContent(media);
      case 'video':
        return Stack(
          fit: StackFit.expand,
          children: [
            _buildPhotoContent(media),
            Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      case 'audio':
        return Container(
          color: Colors.blueGrey[200],
          child: const Center(
            child: Icon(Icons.audiotrack, size: 40, color: Colors.white70),
          ),
        );
      case 'text':
        return Container(
          padding: const EdgeInsets.all(8),
          color: Colors.grey[200],
          child: Text(
            media.content ?? 'No content',
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        );
      default:
        return Container(color: Colors.grey);
    }
  }
  
  /// Get icon for media type
  IconData _getMediaTypeIcon(String type) {
    switch (type) {
      case 'photo':
        return Icons.photo;
      case 'video':
        return Icons.videocam;
      case 'audio':
        return Icons.audiotrack;
      case 'text':
        return Icons.text_snippet;
      default:
        return Icons.attachment;
    }
  }
  
  /// Build photo content
  Widget _buildPhotoContent(ScrapbookMedia media) {
    // In a real app, this would load from the URL
    // For now, use a placeholder
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: media.url != null
            ? Image.asset(
                media.url!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.broken_image,
                  size: 40,
                  color: Colors.grey,
                ),
              )
            : const Icon(
                Icons.photo,
                size: 40,
                color: Colors.grey,
              ),
      ),
    );
  }
  
  /// Build video content
  Widget _buildVideoContent(ScrapbookMedia media) {
    // This would be a video player in a real app
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildPhotoContent(media),
        Center(
          child: IconButton(
            icon: const Icon(
              Icons.play_circle_filled,
              size: 60,
              color: Colors.white70,
            ),
            onPressed: () {
              // Would launch video player in a real app
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Video playback not implemented yet')),
              );
            },
          ),
        ),
        if (media.duration != null)
          Positioned(
            right: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _formatDuration(media.duration),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
  
  /// Build audio content
  Widget _buildAudioContent(ScrapbookMedia media) {
    // This would be an audio player in a real app
    return Container(
      height: 80,
      color: Colors.blueGrey[100],
      child: Row(
        children: [
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              // Would play audio in a real app
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Audio playback not implemented yet')),
              );
            },
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (media.caption != null)
                  Text(
                    media.caption!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 4),
                if (media.duration != null)
                  Text(
                    'Duration: ${_formatDuration(media.duration)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
  
  /// Build text content
  Widget _buildTextContent(ScrapbookMedia media) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Text(media.content ?? 'No content'),
    );
  }
  
  /// Show media detail in fullscreen or modal
  void _showMediaDetail(ScrapbookMedia media) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                
                // Media content
                _buildMediaContent(media),
                
                // Media info
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (media.caption != null)
                        Text(
                          media.caption!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        '${_formatDate(media.timestamp)} at ${_formatTimestamp(media.timestamp)}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      if (media.tags.isNotEmpty) ...[  
                        const Text(
                          'Tags',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: media.tags.map((tag) => Chip(
                            label: Text('#$tag'),
                            backgroundColor: Colors.blueGrey[100],
                          )).toList(),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(
                            icon: Icons.share,
                            label: 'Share',
                            onTap: () {
                              Navigator.pop(context);
                              _showShareOptions();
                            },
                          ),
                          if (_isEditing)
                            _buildActionButton(
                              icon: Icons.edit,
                              label: 'Edit',
                              onTap: () {
                                // Would show edit dialog in a real app
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Edit functionality not implemented yet')),
                                );
                              },
                            ),
                          if (_isEditing)
                            _buildActionButton(
                              icon: Icons.delete,
                              label: 'Delete',
                              onTap: () {
                                // Would show delete confirmation in a real app
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Delete functionality not implemented yet')),
                                );
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  /// Build an action button for the detail view
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppConstants.primaryColor),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
