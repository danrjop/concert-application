import 'package:flutter/material.dart';
import '../../models/memories/index.dart';
import '../../widgets/memories/index.dart';
import '../scrapbooks/scrapbook_detail_screen.dart';

/// Screen that displays the user's collection of scrapbooks.
/// Scrapbooks can be viewed, created, edited, and shared from here.
/// 
/// This is the main entry point to the scrapbook feature of the app.
class ScrapbooksScreen extends StatefulWidget {
  const ScrapbooksScreen({super.key});

  @override
  State<ScrapbooksScreen> createState() => _ScrapbooksScreenState();
}

class _ScrapbooksScreenState extends State<ScrapbooksScreen> {
  // Mock data for scrapbooks - will be replaced with Supabase fetch
  final Map<int, List<ScrapbookItem>> _scrapbooksByYear = {
    2025: [
      ScrapbookItem(id: '1', title: 'EDC Las Vegas', date: 'May 15, 2025', imageUrl: 'assets/images/concert1.jpg'),
      ScrapbookItem(id: '2', title: 'Coachella', date: 'April 10, 2025', imageUrl: 'assets/images/concert2.jpg'),
    ],
    2024: [
      ScrapbookItem(id: '3', title: 'Lollapalooza', date: 'August 3, 2024', imageUrl: 'assets/images/concert3.jpg'),
      ScrapbookItem(id: '4', title: 'Rolling Loud', date: 'July 25, 2024', imageUrl: 'assets/images/concert4.jpg'),
    ],
  };

  // Show the create new scrapbook dialog
  void _showCreateScrapbookDialog(int year) {
    showDialog(
      context: context,
      builder: (context) => CreateScrapbookDialog(
        year: year,
        onScrapbookCreated: _handleScrapbookCreated,
      ),
    );
  }

  // Handle creation of a new scrapbook
  void _handleScrapbookCreated(String title, String date, int year, Map<String, dynamic> additionalData) {
    // This would add a new scrapbook in a real app
    setState(() {
      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      final newScrapbook = ScrapbookItem(
        id: newId,
        title: title,
        date: date,
        imageUrl: 'assets/images/concert_placeholder.jpg',
        venue: additionalData['venue'],
        artists: additionalData['artists'],
        genres: additionalData['genres'],
        isCollaborative: additionalData['isCollaborative'] ?? false,
        createdAt: additionalData['createdAt'],
        updatedAt: additionalData['updatedAt'],
        mediaCount: 0, // New scrapbook has no media yet
      );
      
      if (_scrapbooksByYear.containsKey(year)) {
        _scrapbooksByYear[year]!.add(newScrapbook);
      } else {
        _scrapbooksByYear[year] = [newScrapbook];
      }
    });
    
    // TODO: Create scrapbook in Supabase
    // Future implementation would look something like:
    // SupabaseClient client = Supabase.instance.client;
    // client.from('scrapbooks').insert(newScrapbook.toJson()).execute();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('New scrapbook "$title" created for $year')),
    );
  }

  // Handle when a scrapbook is selected
  void _handleScrapbookSelected(ScrapbookItem scrapbook) {
    // Navigate to scrapbook detail view
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScrapbookDetailScreen(
          scrapbook: scrapbook,
          source: 'scrapbooks_screen',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrapbooksTab(
      scrapbooksByYear: _scrapbooksByYear,
      onAddScrapbook: _showCreateScrapbookDialog,
      onScrapbookSelected: _handleScrapbookSelected,
    );
  }
}
