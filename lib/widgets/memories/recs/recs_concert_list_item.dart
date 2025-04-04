import 'package:flutter/material.dart';
import '../../../models/concert.dart';
import '../../../constants/app_constants.dart';

class RecsConcertListItem extends StatelessWidget {
  final Concert concert;
  final VoidCallback onTap;
  final int index;
  final VoidCallback onAddToWantToGo;
  final VoidCallback onHideRec;

  const RecsConcertListItem({
    super.key,
    required this.concert,
    required this.onTap,
    required this.index,
    required this.onAddToWantToGo,
    required this.onHideRec,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Index number
            Container(
              width: 28,
              alignment: Alignment.center,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
            ),
            
            // Concert details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Concert name
                    Text(
                      concert.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Venue
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            concert.venue,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 2),
                    
                    // Artists
                    Row(
                      children: [
                        const Icon(Icons.person, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            concert.artists.join(', '),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 2),
                    
                    // Genres
                    Row(
                      children: [
                        const Icon(Icons.music_note, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            concert.genres.join(', '),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Right side column with date at top, recommendation rating, and icons at bottom
            SizedBox(
              height: 90, // Set a fixed height for the column
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date at the top right
                  Text(
                    _formatDate(concert.date),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  
                  // Recommended rating
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.thumb_up,
                        size: 16,
                        color: Colors.purple,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Rec: ${concert.rating.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  
                  // Action buttons in a horizontal row at the bottom
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Add to Want to Go button
                      IconButton(
                        icon: const Icon(Icons.bookmark_outline, size: 24),
                        onPressed: onAddToWantToGo,
                        color: Colors.amber,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        visualDensity: VisualDensity.compact,
                        tooltip: 'Add to Want to Go',
                      ),
                      
                      // Hide recommendation
                      IconButton(
                        icon: const Icon(Icons.close, size: 24),
                        onPressed: onHideRec,
                        color: Colors.grey,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        visualDensity: VisualDensity.compact,
                        tooltip: 'Hide Recommendation',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
