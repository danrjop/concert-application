import 'package:flutter/material.dart';
import '../../../models/memories/index.dart';
import '../utils/media_formatters.dart';
import '../utils/media_builders.dart';

class ThematicView extends StatelessWidget {
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
    
    // Group media by section (pre-show, main-show, post-show)
    final Map<String, List<ScrapbookMedia>> mediaBySection = {};
    
    for (final media in mediaItems) {
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
                MediaFormatters.formatSectionName(section),
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
