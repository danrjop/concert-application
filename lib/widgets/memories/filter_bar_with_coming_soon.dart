import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class FilterBarWithComingSoon extends StatelessWidget {
  final String selectedCity;
  final List<String> cities;
  final String selectedGenre;
  final List<String> genres;
  final bool isComingSoon;
  final int comingSoonDays;
  final Function() onAdvancedFiltersPressed;
  final Function(String) onCitySelected;
  final Function(bool) onComingSoonToggled;
  final Function(String) onGenreSelected;

  const FilterBarWithComingSoon({
    super.key,
    required this.selectedCity,
    required this.cities,
    required this.selectedGenre,
    required this.genres,
    required this.isComingSoon,
    required this.comingSoonDays,
    required this.onAdvancedFiltersPressed,
    required this.onCitySelected,
    required this.onComingSoonToggled,
    required this.onGenreSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Advanced Filter Button
            FilterChip(
              label: const Row(
                children: [
                  Icon(Icons.tune, size: 18),
                  SizedBox(width: 4),
                  Text('Filter'),
                ],
              ),
              onSelected: (_) => onAdvancedFiltersPressed(),
              selected: false,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? AppConstants.darkGreyColor
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]!
                      : Colors.grey[300]!,
                ),
              ),
            ),
            const SizedBox(width: 8),
            
            // City Filter
            FilterChip(
              label: Text(selectedCity == cities.first ? 'City' : selectedCity),
              selected: selectedCity != cities.first,
              onSelected: (_) {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => ListView.builder(
                    itemCount: cities.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(cities[index]),
                      selected: selectedCity == cities[index],
                      onTap: () {
                        onCitySelected(cities[index]);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? AppConstants.darkGreyColor
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]!
                      : Colors.grey[300]!,
                ),
              ),
            ),
            const SizedBox(width: 8),
            
            // Coming Soon Filter (replaced Open Now)
            FilterChip(
              label: Text(isComingSoon 
                ? 'Next $comingSoonDays days' 
                : 'Coming Soon'),
              selected: isComingSoon,
              onSelected: onComingSoonToggled,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? AppConstants.darkGreyColor
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]!
                      : Colors.grey[300]!,
                ),
              ),
            ),
            const SizedBox(width: 8),
            
            // Genre Filter
            FilterChip(
              label: Text(selectedGenre == genres.first ? 'Genre' : selectedGenre),
              selected: selectedGenre != genres.first,
              onSelected: (_) {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => ListView.builder(
                    itemCount: genres.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(genres[index]),
                      selected: selectedGenre == genres[index],
                      onTap: () {
                        onGenreSelected(genres[index]);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? AppConstants.darkGreyColor
                  : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]!
                      : Colors.grey[300]!,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
