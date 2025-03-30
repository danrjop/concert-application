# Supabase Implementation for Cities

This directory contains the database schema and scripts needed to set up the cities table in Supabase.

## Schema

The cities table has the following schema:

- `id`: UUID primary key
- `name`: City name (required)
- `state`: US state name (optional)
- `province`: Canadian province or other regional division (optional)
- `country`: Country name (required)
- `search_vector`: Automatically generated tsvector for full-text search
- `created_at`: Timestamp when the record was created
- `updated_at`: Timestamp when the record was last updated

## Setup Instructions

1. Run the migration script in the Supabase SQL editor:
   - Navigate to the Supabase dashboard for your project
   - Go to the SQL Editor
   - Copy and paste the contents of `migrations/20250329000000_create_cities_table.sql`
   - Run the script

2. Seed the database with initial city data:
   - Update the `scripts/seed_cities.js` file with your Supabase URL and anon key
   - Run the script:
     ```
     cd supabase/scripts
     npm install @supabase/supabase-js
     node seed_cities.js
     ```

## Usage in the Application

The application can switch between using the client-side city list and the Supabase implementation:

1. Default mode is set to use the client-side list (`CityServiceMode.fallback`)
2. Toggle between modes using the `CityServiceTestWidget` in the home city screen
3. For production, you should set the default mode to `CityServiceMode.api` in the `CityServiceProvider` constructor

## Row Level Security

The cities table is set up with the following security rules:

- Anyone can read city data
- Only authenticated users with the 'admin' role can insert, update, or delete cities

This ensures that city data is protected from unauthorized modifications while remaining accessible to all users.
