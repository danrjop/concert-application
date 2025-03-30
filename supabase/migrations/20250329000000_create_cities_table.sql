-- Create cities table
CREATE TABLE cities (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  state TEXT,  -- For US states
  province TEXT, -- For Canadian provinces and others
  country TEXT NOT NULL,
  -- Useful for searching
  search_vector tsvector GENERATED ALWAYS AS (
    to_tsvector('english', name) || 
    to_tsvector('english', COALESCE(state, '')) || 
    to_tsvector('english', COALESCE(province, '')) ||
    to_tsvector('english', country)
  ) STORED,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for faster text search
CREATE INDEX cities_search_idx ON cities USING GIN (search_vector);

-- Create index on name for fast lookups
CREATE INDEX cities_name_idx ON cities (name);

-- Create index on country for filtering
CREATE INDEX cities_country_idx ON cities (country);

-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to update timestamp on update
CREATE TRIGGER update_cities_updated_at
BEFORE UPDATE ON cities
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Row Level Security policies
ALTER TABLE cities ENABLE ROW LEVEL SECURITY;

-- Anyone can read cities
CREATE POLICY "Anyone can read cities" 
ON cities FOR SELECT 
USING (true);

-- Only authenticated users with specific roles can insert/update/delete
CREATE POLICY "Only admins can insert cities" 
ON cities FOR INSERT 
TO authenticated
USING (auth.jwt() ->> 'role' = 'admin');

CREATE POLICY "Only admins can update cities" 
ON cities FOR UPDATE
TO authenticated
USING (auth.jwt() ->> 'role' = 'admin');

CREATE POLICY "Only admins can delete cities" 
ON cities FOR DELETE
TO authenticated
USING (auth.jwt() ->> 'role' = 'admin');
