import 'package:flutter/material.dart';
import '../../../models/memories/index.dart';
import '../utils/media_builders.dart';

class GridMediaView extends StatelessWidget {
  final List<ScrapbookMedia> mediaItems;
  final Function(ScrapbookMedia) onMediaTap;

  const GridMediaView({
    Key? key,
    required this.mediaItems,
    required this.onMediaTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (mediaItems.isEmpty) {
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
      itemCount: mediaItems.length,
      itemBuilder: (context, index) {
        final media = mediaItems[index];
        return GestureDetector(
          onTap: () => onMediaTap(media),
          child: Stack(
            fit: StackFit.expand,
            children: [
              MediaBuilders.buildMediaThumbnail(context, media),
              
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
            ],
          ),
        );
      },
    );
  }
}
