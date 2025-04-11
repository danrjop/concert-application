import 'package:flutter/material.dart';
import '../../../models/memories/index.dart';
import '../utils/media_builders.dart';
import '../utils/media_dialogs.dart';

class GridMediaView extends StatefulWidget {
  final List<ScrapbookMedia> mediaItems;
  final Function(ScrapbookMedia) onMediaTap;

  const GridMediaView({
    Key? key,
    required this.mediaItems,
    required this.onMediaTap,
  }) : super(key: key);

  @override
  State<GridMediaView> createState() => _GridMediaViewState();
}

class _GridMediaViewState extends State<GridMediaView> {
  bool _isSelectionMode = false;
  Set<String> _selectedItems = {};

  void _toggleSelection(String mediaId) {
    setState(() {
      if (_selectedItems.contains(mediaId)) {
        _selectedItems.remove(mediaId);
      } else {
        _selectedItems.add(mediaId);
      }

      // If no items are selected, exit selection mode
      if (_selectedItems.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  void _enterSelectionMode(String mediaId) {
    setState(() {
      _isSelectionMode = true;
      _selectedItems.add(mediaId);
    });
  }

  void _cancelSelection() {
    setState(() {
      _isSelectionMode = false;
      _selectedItems.clear();
    });
  }

  void _deleteSelectedItems() {
    // In a real implementation, this would actually delete the items
    // For now, just show a confirmation that it would delete them
    final count = _selectedItems.length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Deleted $count items')),
    );
    setState(() {
      _isSelectionMode = false;
      _selectedItems.clear();
    });
  }

  void _showAddMediaOptions() {
    MediaDialogs.showAddMediaSheet(context, (type, capture) {
      // This would call back to the parent screen to add media
      // For now, just show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Adding new $type media from ${capture ? "camera" : "gallery"}')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mediaItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No media added yet.'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _showAddMediaOptions,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Add Media'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }
    
    return Stack(
      children: [
        // Grid of media items
        GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: widget.mediaItems.length,
          itemBuilder: (context, index) {
            final media = widget.mediaItems[index];
            final isSelected = _selectedItems.contains(media.id);
            
            return GestureDetector(
              onTap: () {
                if (_isSelectionMode) {
                  _toggleSelection(media.id);
                } else {
                  widget.onMediaTap(media);
                }
              },
              onLongPress: () {
                if (!_isSelectionMode) {
                  _enterSelectionMode(media.id);
                }
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Media thumbnail
                  Container(
                    decoration: BoxDecoration(
                      border: isSelected 
                        ? Border.all(color: Colors.blue, width: 3)
                        : null,
                    ),
                    child: MediaBuilders.buildMediaThumbnail(context, media),
                  ),
                  
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
                        MediaBuilders.getMediaTypeIcon(media.type),
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                  
                  // Selection indicator
                  if (isSelected)
                    Positioned(
                      left: 4,
                      top: 4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        
        // Selection mode controls
        if (_isSelectionMode)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.8),
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: _cancelSelection,
                    icon: const Icon(Icons.close, color: Colors.white),
                    tooltip: 'Cancel',
                  ),
                  Text(
                    '${_selectedItems.length} selected',
                    style: const TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    onPressed: _deleteSelectedItems,
                    icon: const Icon(Icons.delete, color: Colors.white),
                    tooltip: 'Delete Selected',
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
