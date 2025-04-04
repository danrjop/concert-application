import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class AdvancedFiltersForBeen extends StatefulWidget {
  final String selectedCity;
  final List<String> cities;
  final String selectedGenre;
  final List<String> genres;
  final Function(String, String) onApplyFilters;

  const AdvancedFiltersForBeen({
    super.key,
    required this.selectedCity,
    required this.cities,
    required this.selectedGenre,
    required this.genres,
    required this.onApplyFilters,
  });

  @override
  State<AdvancedFiltersForBeen> createState() => _AdvancedFiltersForBeenState();
}

class _AdvancedFiltersForBeenState extends State<AdvancedFiltersForBeen> {
  late String _selectedCity;
  late String _selectedGenre;
  
  @override
  void initState() {
    super.initState();
    _selectedCity = widget.selectedCity;
    _selectedGenre = widget.selectedGenre;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Advanced Filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    const Text(
                      'City',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: widget.cities.map((city) {
                        return FilterChip(
                          label: Text(city),
                          selected: _selectedCity == city,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCity = selected ? city : widget.cities.first;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    
                    const Text(
                      'Genre',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: widget.genres.map((genre) {
                        return FilterChip(
                          label: Text(genre),
                          selected: _selectedGenre == genre,
                          onSelected: (selected) {
                            setState(() {
                              _selectedGenre = selected ? genre : widget.genres.first;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    
                    // Additional filter options could be added here
                    const SizedBox(height: 20),
                    
                    // Rating Range Slider for Been tab
                    const Text(
                      'Rating Range',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RangeSlider(
                      values: const RangeValues(3, 5),
                      min: 1,
                      max: 5,
                      divisions: 8,
                      labels: const RangeLabels('3.0', '5.0'),
                      onChanged: (RangeValues values) {
                        // Handle rating range changes
                      },
                      activeColor: AppConstants.primaryColor,
                    ),
                    
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        // Apply the filters and close the sheet
                        widget.onApplyFilters(_selectedCity, _selectedGenre);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
