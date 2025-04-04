import 'package:flutter/material.dart';

class Concert {
  final String id;
  final String name;
  final String venue;
  final List<String> artists;
  final List<String> genres;
  final DateTime date;
  final double rating; // User rating from 0.0 to 5.0
  
  const Concert({
    required this.id,
    required this.name,
    required this.venue,
    required this.artists,
    required this.genres,
    required this.date,
    required this.rating,
  });

  // Create a dummy concert for preview/testing
  factory Concert.dummy({int index = 0}) {
    final List<String> dummyVenues = [
      'Madison Square Garden', 'The Fillmore', 'Red Rocks Amphitheatre',
      'House of Blues', 'The Roxy', 'Bowery Ballroom', 'Radio City Music Hall'
    ];
    
    final List<List<String>> dummyArtists = [
      ['Taylor Swift', 'Ed Sheeran'],
      ['Kendrick Lamar', 'J. Cole'],
      ['Billie Eilish'],
      ['The Weeknd', 'Doja Cat'],
      ['Bruno Mars', 'Anderson .Paak'],
      ['Lady Gaga'],
      ['Coldplay'],
      ['Beyoncé'],
    ];
    
    final List<List<String>> dummyGenres = [
      ['Pop', 'Rock'],
      ['Hip Hop', 'Rap'],
      ['Alternative', 'Indie'],
      ['R&B', 'Soul'],
      ['EDM', 'Dance'],
      ['Jazz'],
      ['Folk', 'Acoustic'],
      ['Classical'],
    ];

    // Generate a random date within the last year
    final now = DateTime.now();
    final daysAgo = (index * 30) % 365; // Spread concerts over the past year
    final concertDate = now.subtract(Duration(days: daysAgo));
    
    // Generate a random rating between 3.0 and 5.0
    final rating = 3.0 + (index % 21) / 10; // Ratings between 3.0 and 5.0
    
    return Concert(
      id: 'concert-${index.toString().padLeft(3, '0')}',
      name: 'Concert Experience ${index + 1}',
      venue: dummyVenues[index % dummyVenues.length],
      artists: dummyArtists[index % dummyArtists.length],
      genres: dummyGenres[index % dummyGenres.length],
      date: concertDate,
      rating: rating,
    );
  }

  // Generate a list of dummy concerts for testing
  static List<Concert> generateDummyConcerts(int count) {
    return List.generate(
      count, 
      (index) => Concert.dummy(index: index)
    );
  }
}
