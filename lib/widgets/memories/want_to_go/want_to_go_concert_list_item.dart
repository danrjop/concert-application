import 'package:flutter/material.dart';
import '../../../models/concert.dart';
import '../../../constants/app_constants.dart';

class WantToGoConcertListItem extends StatelessWidget {
  final Concert concert;
  final VoidCallback onTap;
  final int index;
  final VoidCallback onBuyTickets;
  final VoidCallback onAddToBeen;
  final VoidCallback onRemoveFromWantToGo;

  const WantToGoConcertListItem({
    super.key,
    required this.concert,
    required this.onTap,
    required this.index,
    required this.onBuyTickets,
    required this.onAddToBeen,
    required this.onRemoveFromWantToGo,
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
            
            // Right side column with date at top and icons at bottom
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
                  
                  // Action buttons in a horizontal row at the bottom
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Buy tickets button
                      IconButton(
                        icon: const Icon(Icons.confirmation_number_outlined, size: 24),
                        onPressed: onBuyTickets,
                        color: Colors.green,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        visualDensity: VisualDensity.compact,
                        tooltip: 'Buy Tickets',
                      ),
                      
                      // Add to been button
                      IconButton(
                        icon: const Icon(Icons.check_circle_outline, size: 24),
                        onPressed: onAddToBeen,
                        color: AppConstants.primaryColor,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        visualDensity: VisualDensity.compact,
                        tooltip: 'Add to Been',
                      ),
                      
                      // Remove from Want to go button (filled bookmark)
                      IconButton(
                        icon: const Icon(Icons.bookmark, size: 24),
                        onPressed: onRemoveFromWantToGo,
                        color: Colors.amber,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        visualDensity: VisualDensity.compact,
                        tooltip: 'Remove from Want to Go',
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
