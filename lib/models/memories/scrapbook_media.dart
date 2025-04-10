import 'package:flutter/material.dart';

/// Represents a single media item in a scrapbook
/// 
/// This can be a photo, video, audio clip, or text note.
/// Each media item has metadata like timestamp, tags, and section.
class ScrapbookMedia {
  /// Unique identifier for this media item
  final String id;
  
  /// Type of media - 'photo', 'video', 'audio', or 'text'
  final String type;
  
  /// URL or asset path to the media (for photos, videos, audio)
  final String? url;
  
  /// Caption or title for the media
  final String? caption;
  
  /// Text content (for text type)
  final String? content;
  
  /// When this media was captured
  final DateTime timestamp;
  
  /// Tags for organization and searching
  final List<String> tags;
  
  /// Section in the concert timeline - 'pre-show', 'main-show', or 'post-show'
  final String section;
  
  /// Duration for time-based media (video, audio)
  final Duration? duration;

  const ScrapbookMedia({
    required this.id,
    required this.type,
    this.url,
    this.caption,
    this.content,
    required this.timestamp,
    required this.tags,
    required this.section,
    this.duration,
  });

  /// Convert to JSON for Supabase storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'url': url,
      'caption': caption,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'tags': tags,
      'section': section,
      'duration': duration?.inSeconds,
    };
  }

  /// Create a ScrapbookMedia object from Supabase JSON data
  static ScrapbookMedia fromJson(Map<String, dynamic> json) {
    return ScrapbookMedia(
      id: json['id'],
      type: json['type'],
      url: json['url'],
      caption: json['caption'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      tags: List<String>.from(json['tags']),
      section: json['section'],
      duration: json['duration'] != null ? Duration(seconds: json['duration']) : null,
    );
  }
  
  /// Create a copy of the media with updated fields
  ScrapbookMedia copyWith({
    String? id,
    String? type,
    String? url,
    String? caption,
    String? content,
    DateTime? timestamp,
    List<String>? tags,
    String? section,
    Duration? duration,
  }) {
    return ScrapbookMedia(
      id: id ?? this.id,
      type: type ?? this.type,
      url: url ?? this.url,
      caption: caption ?? this.caption,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      tags: tags ?? this.tags,
      section: section ?? this.section,
      duration: duration ?? this.duration,
    );
  }
  
  /// Create a basic media item with default values
  static ScrapbookMedia createEmpty(String type) {
    return ScrapbookMedia(
      id: 'tmp_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      timestamp: DateTime.now(),
      tags: [],
      section: 'main-show',
    );
  }
}
