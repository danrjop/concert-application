import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/memories/index.dart';

class ScrapbooksTab extends StatelessWidget {
  final Map<int, List<ScrapbookItem>> scrapbooksByYear;
  final Function(int) onAddScrapbook;
  final Function(ScrapbookItem) onScrapbookSelected;

  const ScrapbooksTab({
    super.key,
    required this.scrapbooksByYear,
    required this.onAddScrapbook,
    required this.onScrapbookSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Get years in descending order (most recent first)
    final List<int> years = scrapbooksByYear.keys.toList()..sort((a, b) => b.compareTo(a));
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: years.length,
      itemBuilder: (context, index) {
        final year = years[index];
        final scrapbooks = scrapbooksByYear[year]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Year header
            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 12),
              child: Text(
                year.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Grid of scrapbook cards
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: scrapbooks.length + 1, // +1 for the "Add" card
              itemBuilder: (context, cardIndex) {
                if (cardIndex == 0) {
                  // "Add new" card (always first)
                  return _buildAddScrapbookCard(year);
                } else {
                  // Regular scrapbook card
                  final scrapbook = scrapbooks[cardIndex - 1];
                  return _buildScrapbookCard(scrapbook);
                }
              },
            ),
            
            // Divider between years
            if (index < years.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(),
              ),
          ],
        );
      },
    );
  }
  
  // Build the "Add new scrapbook" card
  Widget _buildAddScrapbookCard(int year) {
    return InkWell(
      onTap: () => onAddScrapbook(year),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 40,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
  
  // Build a scrapbook card
  Widget _buildScrapbookCard(ScrapbookItem scrapbook) {
    return InkWell(
      onTap: () => onScrapbookSelected(scrapbook),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300], // Placeholder for actual images
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // This would be an actual Image widget in a real app
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.grey[400], // Placeholder for image
                child: Center(
                  child: Icon(
                    Icons.music_note,
                    size: 30,
                    color: Colors.grey[100],
                  ),
                ),
              ),
            ),
            
            // Title overlay at the bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Text(
                  scrapbook.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
