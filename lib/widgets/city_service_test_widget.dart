import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/city/city_service_provider.dart';

class CityServiceTestWidget extends StatelessWidget {
  const CityServiceTestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cityServiceProvider = Provider.of<CityServiceProvider>(context);
    final currentMode = cityServiceProvider.mode;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'City Service Mode',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentMode == CityServiceMode.api 
                          ? 'Using Supabase API' 
                          : 'Using Client-Side List',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        currentMode == CityServiceMode.api 
                          ? 'Cities are fetched from Supabase database' 
                          : 'Cities are loaded from local app memory',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: currentMode == CityServiceMode.api,
                  onChanged: (value) {
                    cityServiceProvider.setMode(
                      value ? CityServiceMode.api : CityServiceMode.fallback
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Switch to ${currentMode == CityServiceMode.api ? 'client-side list' : 'Supabase API'} for testing',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
