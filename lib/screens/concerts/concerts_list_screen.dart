import 'package:flutter/material.dart';
import '../../models/concert.dart';
import 'concert_info_screen.dart';

class ConcertsListScreen extends StatelessWidget {
  const ConcertsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate 10 dummy concerts for preview
    final List<Concert> concerts = Concert.generateDummyConcerts(10);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Concerts'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: concerts.length,
        itemBuilder: (context, index) {
          final concert = concerts[index];
          
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(concert.name),
              subtitle: Text(
                '${concert.artists.join(", ")} • ${concert.venue}'
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 2),
                      Text(concert.rating.toStringAsFixed(1)),
                    ],
                  ),
                  Text(
                    '${concert.date.day}/${concert.date.month}/${concert.date.year}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ConcertInfoScreen(concert: concert),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
