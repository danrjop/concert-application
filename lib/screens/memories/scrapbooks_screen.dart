import 'package:flutter/material.dart';
import '../../models/memories/index.dart';
import '../../widgets/memories/index.dart';

class ScrapbooksScreen extends StatefulWidget {
  const ScrapbooksScreen({super.key});

  @override
  State<ScrapbooksScreen> createState() => _ScrapbooksScreenState();
}

class _ScrapbooksScreenState extends State<ScrapbooksScreen> {
  // Mock data for scrapbooks - in a real app this would come from a database
  final Map<int, List<ScrapbookItem>> _scrapbooksByYear = {
    2025: [
      ScrapbookItem(id: '1', title: 'EDC Las Vegas', date: 'May 15, 2025', imageUrl: 'assets/images/concert1.jpg'),
      ScrapbookItem(id: '2', title: 'Coachella', date: 'April 10, 2025', imageUrl: 'assets/images/concert2.jpg'),
    ],
    2024: [
      ScrapbookItem(id: '3', title: 'Lollapalooza', date: 'August 3, 2024', imageUrl: 'assets/images/concert3.jpg'),
      ScrapbookItem(id: '4', title: 'Rolling Loud', date: 'July 25, 2024', imageUrl: 'assets/images/concert4.jpg'),
      ScrapbookItem(id: '5', title: 'Ultra Music Festival', date: 'March 22, 2024', imageUrl: 'assets/images/concert5.jpg'),
    ],
    2023: [
      ScrapbookItem(id: '6', title: 'Glastonbury', date: 'June 21, 2023', imageUrl: 'assets/images/concert6.jpg'),
      ScrapbookItem(id: '7', title: 'Tomorrowland', date: 'July 20, 2023', imageUrl: 'assets/images/concert7.jpg'),
    ],
    2022: [
      ScrapbookItem(id: '8', title: 'Burning Man', date: 'August 28, 2022', imageUrl: 'assets/images/concert8.jpg'),
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
  void _handleScrapbookCreated(String title, String date, int year) {
    // This would add a new scrapbook in a real app
    setState(() {
      final newId = DateTime.now().millisecondsSinceEpoch.toString();
      final newScrapbook = ScrapbookItem(
        id: newId,
        title: title,
        date: date,
        imageUrl: 'assets/images/concert_placeholder.jpg',
      );
      
      if (_scrapbooksByYear.containsKey(year)) {
        _scrapbooksByYear[year]!.add(newScrapbook);
      } else {
        _scrapbooksByYear[year] = [newScrapbook];
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('New scrapbook created for $year')),
    );
  }

  // Handle when a scrapbook is selected
  void _handleScrapbookSelected(ScrapbookItem scrapbook) {
    // Navigate to scrapbook detail view (to be implemented)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening scrapbook: ${scrapbook.title}')),
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
