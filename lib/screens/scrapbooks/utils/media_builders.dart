import 'package:flutter/material.dart';
import '../../../models/memories/index.dart';
import 'media_formatters.dart';

/// Utility class for building media-related widgets
class MediaBuilders {
  /// Get icon for media type
  static IconData getMediaTypeIcon(String type) {
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
  
  /// Build media content based on type
  static Widget buildMediaContent(BuildContext context, ScrapbookMedia media) {
    switch (media.type) {
      case 'photo':
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: buildPhotoContent(media),
        );
      case 'video':
        return AspectRatio(
          aspectRatio: 16 / 9,
          child: buildVideoContent(context, media),
        );
      case 'audio':
        return buildAudioContent(context, media);
      case 'text':
        return buildTextContent(media);
      default:
        return const SizedBox.shrink();
    }
  }
  
  /// Build media thumbnail
  static Widget buildMediaThumbnail(BuildContext context, ScrapbookMedia media) {
    switch (media.type) {
      case 'photo':
        return buildPhotoContent(media);
      case 'video':
        return Stack(
          fit: StackFit.expand,
          children: [
            buildPhotoContent(media),
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
  
  /// Build photo content
  static Widget buildPhotoContent(ScrapbookMedia media) {
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
  static Widget buildVideoContent(BuildContext context, ScrapbookMedia media) {
    // This would be a video player in a real app
    return Stack(
      fit: StackFit.expand,
      children: [
        buildPhotoContent(media),
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
                MediaFormatters.formatDuration(media.duration),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
  
  /// Build audio content
  static Widget buildAudioContent(BuildContext context, ScrapbookMedia media) {
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
                    'Duration: ${MediaFormatters.formatDuration(media.duration)}',
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
  static Widget buildTextContent(ScrapbookMedia media) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Text(media.content ?? 'No content'),
    );
  }
  
  /// Build an action button for the detail view
  static Widget buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color primaryColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: primaryColor),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
