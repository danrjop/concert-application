import 'package:flutter/material.dart';
import '../../../models/memories/index.dart';
import '../utils/media_formatters.dart';
import '../utils/media_builders.dart';

class TimelineView extends StatelessWidget {
  final List<ScrapbookMedia> mediaItems;
  final Function(ScrapbookMedia) onMediaTap;

  const TimelineView({
    Key? key,
    required this.mediaItems,
    required this.onMediaTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (mediaItems.isEmpty) {
      return const Center(child: Text('No media added yet. Tap + to add memories.'));
    }
    
    // Sort media by timestamp
    final sortedMedia = List<ScrapbookMedia>.from(mediaItems)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedMedia.length,
      itemBuilder: (context, index) {
        final media = sortedMedia[index];
        final bool showDate = index == 0 || 
          !MediaFormatters.isSameDay(media.timestamp, sortedMedia[index - 1].timestamp);
          
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show date header if this is a new day
            if (showDate)
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Text(
                  MediaFormatters.formatDate(media.timestamp),
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
              child: InkWell(
                onTap: () => onMediaTap(media),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Media content
                    MediaBuilders.buildMediaContent(context, media),
                    
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
                            MediaFormatters.formatTimestamp(media.timestamp),
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
            ),
          ],
        );
      },
    );
  }
}
