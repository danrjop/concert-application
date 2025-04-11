import 'package:flutter/material.dart';
import '../../../models/memories/index.dart';
import '../utils/media_formatters.dart';
import '../utils/media_builders.dart';

class ThematicView extends StatelessWidget {
  // Renamed from ThematicView but keeping the class name unchanged
  // to maintain compatibility with other parts of the app
  final List<ScrapbookMedia> mediaItems;
  final Function(ScrapbookMedia) onMediaTap;

  const ThematicView({
    Key? key,
    required this.mediaItems,
    required this.onMediaTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (mediaItems.isEmpty) {
      return const Center(child: Text('No media added yet. Tap + to add memories.'));
    }
    
    // Group media by themes (based on tags or detected content)
    final Map<String, List<ScrapbookMedia>> mediaByTheme = {};
    
    // Create theme categories
    mediaByTheme['Group Pictures'] = [];
    mediaByTheme['Performance Highlights'] = [];
    mediaByTheme['Venue & Atmosphere'] = [];
    mediaByTheme['Food & Drinks'] = [];
    
    // Categorize media based on tags and content
    for (final media in mediaItems) {
      // Check tags to determine themes
      if (media.tags.any((tag) => ['friends', 'group', 'people', 'crowd', 'selfie'].contains(tag))) {
        mediaByTheme['Group Pictures']!.add(media);
      }
      
      if (media.tags.any((tag) => ['performance', 'stage', 'artist', 'band', 'song', 'highlight'].contains(tag))) {
        mediaByTheme['Performance Highlights']!.add(media);
      }
      
      if (media.tags.any((tag) => ['venue', 'stage', 'lights', 'atmosphere', 'effects'].contains(tag))) {
        mediaByTheme['Venue & Atmosphere']!.add(media);
      }
      
      if (media.tags.any((tag) => ['food', 'drinks', 'merch', 'souvenirs'].contains(tag))) {
        mediaByTheme['Food & Drinks']!.add(media);
      }
    }
    
    // Remove empty themes
    mediaByTheme.removeWhere((key, value) => value.isEmpty);
    
    // Get all themes
    final List<String> themes = mediaByTheme.keys.toList();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: themes.length,
      itemBuilder: (context, index) {
        final theme = themes[index];
        final themeMedia = mediaByTheme[theme]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Padding(
              padding: const EdgeInsets.only(bottom: 16, top: 16),
              child: Text(
                theme,
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
              itemCount: themeMedia.length,
              itemBuilder: (context, mediaIndex) {
                final media = themeMedia[mediaIndex];
                return GestureDetector(
                  onTap: () => onMediaTap(media),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: MediaBuilders.buildMediaThumbnail(context, media),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
