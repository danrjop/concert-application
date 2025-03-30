# Home City Supabase Implementation

This guide explains how to set up and use the City functionality in your application with Supabase integration.

## What's Been Implemented

1. **Supabase Database Schema**: SQL migration script for creating the cities table
2. **Data Seeding**: Script to populate the cities table with initial data
3. **City Service Implementation**: Service layer for both client-side and Supabase modes
4. **Toggle Widget**: A UI component to easily switch between implementations for testing

## Setup Instructions

### 1. Flutter App Configuration

The `CityServiceProvider` has been added to your app's providers in `main.dart`. You can access it through Provider.of<CityServiceProvider> from any context below the top-level widget.

```dart
ChangeNotifierProvider(
  create: (_) => CityServiceProvider(),
),
```

### 2. Supabase Database Setup

1. **Create the Cities Table**: 
   - Navigate to Supabase Dashboard > SQL Editor
   - Run the migration script in `/supabase/migrations/20250329000000_create_cities_table.sql`

2. **Seed Initial City Data**:
   - Update the Supabase URL and anon key in `/supabase/scripts/seed_cities.js`
   - Run the script:
   ```bash
   cd supabase/scripts
   npm install @supabase/supabase-js
   node seed_cities.js
   ```

### 3. Testing the Implementation

1. Navigate to the Change Home City screen:
   ```dart
   Navigator.pushNamed(context, '/change_home_city');
   ```

2. Use the toggle at the top of the screen to switch between:
   - Client-side city list (default)
   - Supabase API mode

3. Search for cities and select one as your home city to test the functionality

## How It Works

### CityServiceProvider

This acts as a facade that delegates to either:
- `CityServiceFallback`: Uses the client-side list of cities (from `constants/cities.dart`)
- `CityService`: Connects to Supabase to fetch city data

You can switch between modes with:
```dart
final cityServiceProvider = Provider.of<CityServiceProvider>(context, listen: false);
cityServiceProvider.setMode(CityServiceMode.api); // or CityServiceMode.fallback
```

### City Model

The `City` model includes:
- `id`: Unique identifier (UUID in Supabase, generated ID in fallback)
- `name`: City name
- `state`: US state (optional)
- `province`: Canadian province or similar (optional)
- `country`: Country name
- Helper methods for formatting city names

### UserProfileService Integration

The `UserProfileService` has been updated to store:
- `homeCityId`: ID of the selected city
- `homeCityName`: Name of the city
- `homeCityDisplay`: Formatted city display name (e.g., "New York, NY, USA")

## Going to Production

When ready to deploy to production:

1. Set `_showServiceToggle = false` in `ChangeHomeCityScreen` to hide the toggle widget
2. Update `CityServiceProvider` constructor to use Supabase mode by default:
   ```dart
   CityServiceProvider({CityServiceMode mode = CityServiceMode.api}) {
     _mode = mode;
   }
   ```

## Troubleshooting

If you encounter issues with the Provider not being found, make sure:
1. You've performed a hot restart (not just hot reload)
2. The CityServiceProvider is properly added to your MultiProvider in main.dart
3. The widget trying to access the provider is a descendant of the MultiProvider

## Supabase Schema

The cities table has the following structure:
- `id`: UUID primary key
- `name`: City name (required)
- `state`: US state (optional)
- `province`: Canadian province (optional)
- `country`: Country name (required)
- `search_vector`: Full-text search column
- `created_at`: Creation timestamp
- `updated_at`: Last update timestamp
