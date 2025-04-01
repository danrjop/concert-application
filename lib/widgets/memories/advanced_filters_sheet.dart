import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class AdvancedFiltersSheet extends StatefulWidget {
  final String selectedCity;
  final List<String> cities;
  final String selectedGenre;
  final List<String> genres;
  final bool isOpenNow;
  final Function(String, String, bool) onApplyFilters;

  const AdvancedFiltersSheet({
    super.key,
    required this.selectedCity,
    required this.cities,
    required this.selectedGenre,
    required this.genres,
    required this.isOpenNow,
    required this.onApplyFilters,
  });

  @override
  State<AdvancedFiltersSheet> createState() => _AdvancedFiltersSheetState();
}

class _AdvancedFiltersSheetState extends State<AdvancedFiltersSheet> {
  late String _selectedCity;
  late String _selectedGenre;
  late bool _isOpenNow;
  
  @override
  void initState() {
    super.initState();
    _selectedCity = widget.selectedCity;
    _selectedGenre = widget.selectedGenre;
    _isOpenNow = widget.isOpenNow;
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
                    const SizedBox(height: 20),
                    
                    SwitchListTile(
                      title: const Text('Open Now'),
                      value: _isOpenNow,
                      onChanged: (value) {
                        setState(() {
                          _isOpenNow = value;
                        });
                      },
                    ),
                    
                    // Additional filter options could be added here
                    const SizedBox(height: 20),
                    
                    // Price Range Slider
                    const Text(
                      'Price Range',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RangeSlider(
                      values: const RangeValues(0, 100),
                      min: 0,
                      max: 200,
                      divisions: 10,
                      labels: const RangeLabels('\$0', '\$100'),
                      onChanged: (RangeValues values) {
                        // Handle price range changes
                      },
                    ),
                    
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        // Apply the filters and close the sheet
                        widget.onApplyFilters(_selectedCity, _selectedGenre, _isOpenNow);
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
