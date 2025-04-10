/// Represents a scrapbook for a concert or event
/// 
/// Each scrapbook contains multiple media items and has metadata
/// about the event, such as date, venue, artists, etc.
class ScrapbookItem {
  /// Unique identifier for this scrapbook
  final String id;
  
  /// Title of the concert or event
  final String title;
  
  /// Date of the concert in display format
  final String date;
  
  /// Cover image URL
  final String imageUrl;
  
  /// Optional venue information
  final String? venue;
  
  /// Optional artists information
  final List<String>? artists;
  
  /// Optional genre tags
  final List<String>? genres;
  
  /// Count of media items (can be calculated from media list)
  final int? mediaCount;
  
  /// When the scrapbook was created
  final DateTime? createdAt;
  
  /// When the scrapbook was last modified
  final DateTime? updatedAt;
  
  /// Whether this scrapbook is collaborative
  final bool isCollaborative;
  
  /// Users who can contribute (if collaborative)
  final List<String>? collaborators;

  ScrapbookItem({
    required this.id,
    required this.title,
    required this.date,
    required this.imageUrl,
    this.venue,
    this.artists,
    this.genres,
    this.mediaCount,
    this.createdAt,
    this.updatedAt,
    this.isCollaborative = false,
    this.collaborators,
  });
  
  /// Convert to JSON for Supabase storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'image_url': imageUrl,
      'venue': venue,
      'artists': artists,
      'genres': genres,
      'media_count': mediaCount,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_collaborative': isCollaborative,
      'collaborators': collaborators,
    };
  }

  /// Create a ScrapbookItem from Supabase JSON data
  static ScrapbookItem fromJson(Map<String, dynamic> json) {
    return ScrapbookItem(
      id: json['id'],
      title: json['title'],
      date: json['date'],
      imageUrl: json['image_url'],
      venue: json['venue'],
      artists: json['artists'] != null ? List<String>.from(json['artists']) : null,
      genres: json['genres'] != null ? List<String>.from(json['genres']) : null,
      mediaCount: json['media_count'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      isCollaborative: json['is_collaborative'] ?? false,
      collaborators: json['collaborators'] != null ? List<String>.from(json['collaborators']) : null,
    );
  }
  
  /// Create a copy with updated fields
  ScrapbookItem copyWith({
    String? id,
    String? title,
    String? date,
    String? imageUrl,
    String? venue,
    List<String>? artists,
    List<String>? genres,
    int? mediaCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isCollaborative,
    List<String>? collaborators,
  }) {
    return ScrapbookItem(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      imageUrl: imageUrl ?? this.imageUrl,
      venue: venue ?? this.venue,
      artists: artists ?? this.artists,
      genres: genres ?? this.genres,
      mediaCount: mediaCount ?? this.mediaCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isCollaborative: isCollaborative ?? this.isCollaborative,
      collaborators: collaborators ?? this.collaborators,
    );
  }
}
