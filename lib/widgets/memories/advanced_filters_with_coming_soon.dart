import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class AdvancedFiltersWithComingSoon extends StatefulWidget {
  final String selectedCity;
  final List<String> cities;
  final String selectedGenre;
  final List<String> genres;
  final bool isComingSoon;
  final int comingSoonDays;
  final Function(String, String, bool, int) onApplyFilters;

  const AdvancedFiltersWithComingSoon({
    super.key,
    required this.selectedCity,
    required this.cities,
    required this.selectedGenre,
    required this.genres,
    required this.isComingSoon,
    required this.comingSoonDays,
    required this.onApplyFilters,
  });

  @override
  State<AdvancedFiltersWithComingSoon> createState() => _AdvancedFiltersWithComingSoonState();
}

class _AdvancedFiltersWithComingSoonState extends State<AdvancedFiltersWithComingSoon> {
  late String _selectedCity;
  late String _selectedGenre;
  late bool _isComingSoon;
  late int _comingSoonDays;
  
  // Available options for Coming Soon timeframes
  final List<int> _timeFrameOptions = [3, 7, 14, 30, 90];
  
  @override
  void initState() {
    super.initState();
    _selectedCity = widget.selectedCity;
    _selectedGenre = widget.selectedGenre;
    _isComingSoon = widget.isComingSoon;
    _comingSoonDays = widget.comingSoonDays;
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
                    
                    // Coming Soon section
                    Row(
                      children: [
                        const Text(
                          'Coming Soon',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Switch(
                          value: _isComingSoon,
                          onChanged: (value) {
                            setState(() {
                              _isComingSoon = value;
                            });
                          },
                          activeColor: AppConstants.primaryColor,
                        ),
                      ],
                    ),
                    
                    if (_isComingSoon) ...[
                      const SizedBox(height: 10),
                      
                      const Text(
                        'Time Frame',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      const SizedBox(height: 10),
                      
                      // Time Frame options
                      Wrap(
                        spacing: 8,
                        children: _timeFrameOptions.map((days) {
                          return FilterChip(
                            label: Text('Next $days days'),
                            selected: _comingSoonDays == days,
                            selectedColor: AppConstants.primaryColor.withOpacity(0.2),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _comingSoonDays = days;
                                });
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ],
                    
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
                      activeColor: AppConstants.primaryColor,
                    ),
                    
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        // Apply the filters and close the sheet
                        widget.onApplyFilters(
                          _selectedCity, 
                          _selectedGenre, 
                          _isComingSoon,
                          _comingSoonDays
                        );
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
