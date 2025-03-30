import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_profile_service.dart';
import '../services/city/city_service_provider.dart';
import '../models/city.dart';
import '../widgets/city_service_test_widget.dart';

class ChangeHomeCityScreen extends StatefulWidget {
  const ChangeHomeCityScreen({super.key});

  @override
  _ChangeHomeCityScreenState createState() => _ChangeHomeCityScreenState();
}

class _ChangeHomeCityScreenState extends State<ChangeHomeCityScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<City> _filteredCities = [];
  City? _selectedCity;
  bool _isLoading = false;
  bool _showServiceToggle = false; // For development/testing purposes

  @override
  void initState() {
    super.initState();
    final userProfileService = Provider.of<UserProfileService>(context, listen: false);
    final userProfile = userProfileService.currentUserProfile;
    
    // If user has a home city ID saved, fetch the city object
    if (userProfile?.homeCityId != null) {
      _loadSelectedCity(userProfile!.homeCityId!);
    }
    
    // Only show toggle in debug mode - replace with your own condition if needed
    _showServiceToggle = true; // Set to false for production
  }
  
  // Load city object by ID
  Future<void> _loadSelectedCity(String cityId) async {
    setState(() => _isLoading = true);
    
    try {
      final cityService = Provider.of<CityServiceProvider>(context, listen: false);
      final city = await cityService.getCityById(cityId);
      
      if (city != null) {
        setState(() {
          _selectedCity = city;
          _searchController.text = city.name;
        });
      }
    } catch (e) {
      print('Error loading selected city: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter cities based on search query
  void _filterCities(String query) async {
    if (query.isEmpty) {
      setState(() => _filteredCities = []);
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final cityService = Provider.of<CityServiceProvider>(context, listen: false);
      final cities = await cityService.searchCities(query);
      
      setState(() {
        _filteredCities = cities;
        _isLoading = false;
      });
    } catch (e) {
      print('Error searching cities: $e');
      setState(() => _isLoading = false);
    }
  }

  // Select a city and update the user's home city
  void _selectCity(City city) async {
    setState(() {
      _selectedCity = city;
      _searchController.text = city.name;
      _filteredCities = [];
    });
  }

  // Save the selected city as the user's home city
  void _saveHomeCity() async {
    if (_selectedCity != null) {
      final userProfileService = Provider.of<UserProfileService>(context, listen: false);
      await userProfileService.updateHomeCityWithObject(_selectedCity!);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Home city updated to: ${_selectedCity!.displayName}')),
        );
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a city')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfileService = Provider.of<UserProfileService>(context);
    final userProfile = userProfileService.currentUserProfile;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Home City'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add the city service toggle for development/testing
          if (_showServiceToggle)
            const CityServiceTestWidget(),
            
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current city display
                  if (userProfile?.homeCityName != null && userProfile!.homeCityName!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              const Icon(Icons.location_city, size: 28),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Current Home City',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      userProfile.homeCityDisplay ?? userProfile.homeCityName!,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  
                  // Search field
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search for a city',
                      hintText: 'Start typing a city name',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _filteredCities = [];
                              });
                            },
                          )
                        : null,
                    ),
                    onChanged: _filterCities,
                  ),
                  
                  // Search results
                  Expanded(
                    child: _isLoading 
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredCities.isNotEmpty
                        ? ListView.builder(
                            itemCount: _filteredCities.length,
                            itemBuilder: (context, index) {
                              final city = _filteredCities[index];
                              return ListTile(
                                title: Text(city.name),
                                subtitle: Text(city.displayName),
                                onTap: () => _selectCity(city),
                                trailing: _selectedCity?.id == city.id
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search,
                                  size: 80,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _searchController.text.isEmpty
                                    ? 'Start typing to search for a city'
                                    : 'No cities found for "${_searchController.text}"',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _selectedCity != null ? _saveHomeCity : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('Save'),
        ),
      ),
    );
  }
}
