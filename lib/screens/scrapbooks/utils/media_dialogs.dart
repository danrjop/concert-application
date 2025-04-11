import 'package:flutter/material.dart';
import '../../../models/memories/index.dart';
import '../../../constants/app_constants.dart';
import '../../../utils/share_utils.dart';
import 'media_formatters.dart';
import 'media_builders.dart';

/// Class containing dialog and sheet-related functions for the scrapbook screen
class MediaDialogs {
  /// Shows the template selection dialog
  static void showTemplateDialog(
    BuildContext context, 
    String selectedTheme, 
    String selectedTemplate,
    List<String> templates,
    Function(String) onThemeChanged,
    Function(String) onTemplateSelected,
  ) {
    final screenSize = MediaQuery.of(context).size;
    final maxHeight = screenSize.height * 0.8; // 80% of screen height
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
            maxWidth: screenSize.width * 0.9,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Text(
                      'Choose Template',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Theme selection
                  const Text('Theme', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedTheme,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        items: const [
                          DropdownMenuItem(value: 'Auto', child: Text('Auto (Match Genre)')),
                          DropdownMenuItem(value: 'Light', child: Text('Light')),
                          DropdownMenuItem(value: 'Dark', child: Text('Dark')),
                          DropdownMenuItem(value: 'Vibrant', child: Text('Vibrant')),
                        ],
                        onChanged: (newValue) {
                          if (newValue != null) {
                            onThemeChanged(newValue);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Template selection
                  const Text('Template', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 300, // Increased height for better scrolling
                    child: GridView.builder(
                      shrinkWrap: false, // Using false here to allow scrolling
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: templates.length,
                      itemBuilder: (context, index) {
                        final template = templates[index];
                        final isSelected = template == selectedTemplate;
                        
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            onTemplateSelected(template);
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
                  const SizedBox(height: 16),
                  
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CANCEL'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  /// Get icon for template
  static IconData _getTemplateIcon(String template) {
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
  
  /// Shows share options for a scrapbook
  static void showShareOptions(BuildContext context, String scrapbookTitle) {
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
                'Check out my $scrapbookTitle concert scrapbook!',
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
                'Preparing Instagram story for $scrapbookTitle...',
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
                'Preparing TikTok video for $scrapbookTitle...',
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
                'Generating QR code for $scrapbookTitle...',
              );
            },
          ),
        ],
      ),
    );
  }
  
  /// Shows add media options sheet
  static void showAddMediaSheet(BuildContext context, Function(String, bool) onAddMedia) {
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
                onTap: () {
                  Navigator.pop(context);
                  onAddMedia('photo', true);
                },
              ),
              _buildAddMediaOption(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: () {
                  Navigator.pop(context);
                  onAddMedia('photo', false);
                },
              ),
              _buildAddMediaOption(
                icon: Icons.videocam,
                label: 'Record Video',
                onTap: () {
                  Navigator.pop(context);
                  onAddMedia('video', true);
                },
              ),
              _buildAddMediaOption(
                icon: Icons.video_library,
                label: 'Video Library',
                onTap: () {
                  Navigator.pop(context);
                  onAddMedia('video', false);
                },
              ),
              _buildAddMediaOption(
                icon: Icons.mic,
                label: 'Record Audio',
                onTap: () {
                  Navigator.pop(context);
                  onAddMedia('audio', true);
                },
              ),
              _buildAddMediaOption(
                icon: Icons.text_snippet,
                label: 'Text Note',
                onTap: () {
                  Navigator.pop(context);
                  onAddMedia('text', false);
                },
              ),
              _buildAddMediaOption(
                icon: Icons.note_add,
                label: 'Setlist',
                onTap: () {
                  Navigator.pop(context);
                  onAddMedia('setlist', false);
                },
              ),
              _buildAddMediaOption(
                icon: Icons.location_on,
                label: 'Venue Info',
                onTap: () {
                  Navigator.pop(context);
                  onAddMedia('location', false);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
  
  /// Build an add media option button
  static Widget _buildAddMediaOption({
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

  /// Show media detail in fullscreen or modal
  static void showMediaDetail(
    BuildContext context, 
    ScrapbookMedia media, 
    bool isEditing,
    VoidCallback onShare,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  ) {
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
                MediaBuilders.buildMediaContent(context, media),
                
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
                        '${MediaFormatters.formatDate(media.timestamp)} at ${MediaFormatters.formatTimestamp(media.timestamp)}',
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
                          MediaBuilders.buildActionButton(
                            icon: Icons.share,
                            label: 'Share',
                            onTap: () {
                              Navigator.pop(context);
                              onShare();
                            },
                            primaryColor: AppConstants.primaryColor,
                          ),
                          if (isEditing && onEdit != null)
                            MediaBuilders.buildActionButton(
                              icon: Icons.edit,
                              label: 'Edit',
                              onTap: () {
                                Navigator.pop(context);
                                onEdit();
                              },
                              primaryColor: AppConstants.primaryColor,
                            ),
                          if (isEditing && onDelete != null)
                            MediaBuilders.buildActionButton(
                              icon: Icons.delete,
                              label: 'Delete',
                              onTap: () {
                                Navigator.pop(context);
                                onDelete();
                              },
                              primaryColor: AppConstants.primaryColor,
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
}
