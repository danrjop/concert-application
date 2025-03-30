import { createClient } from '@supabase/supabase-js';

// Initialize Supabase client (replace with your project URL and anon key)
const supabaseUrl = 'YOUR_SUPABASE_URL';
const supabaseKey = 'YOUR_SUPABASE_ANON_KEY';
const supabase = createClient(supabaseUrl, supabaseKey);

// Sample cities data from your current client-side list but with more structure
const citiesData = [
  { name: "Amsterdam", country: "Netherlands" },
  { name: "Athens", country: "Greece" },
  { name: "Atlanta", state: "Georgia", country: "United States" },
  { name: "Auckland", country: "New Zealand" },
  { name: "Austin", state: "Texas", country: "United States" },
  { name: "Bangkok", country: "Thailand" },
  { name: "Barcelona", country: "Spain" },
  { name: "Beijing", country: "China" },
  { name: "Berlin", country: "Germany" },
  { name: "Boston", state: "Massachusetts", country: "United States" },
  { name: "Brussels", country: "Belgium" },
  { name: "Buenos Aires", country: "Argentina" },
  { name: "Cairo", country: "Egypt" },
  { name: "Cape Town", country: "South Africa" },
  { name: "Chicago", state: "Illinois", country: "United States" },
  { name: "Copenhagen", country: "Denmark" },
  { name: "Dallas", state: "Texas", country: "United States" },
  { name: "Delhi", country: "India" },
  { name: "Denver", state: "Colorado", country: "United States" },
  { name: "Detroit", state: "Michigan", country: "United States" },
  { name: "Dubai", country: "United Arab Emirates" },
  { name: "Dublin", country: "Ireland" },
  { name: "Edinburgh", country: "United Kingdom" },
  { name: "Frankfurt", country: "Germany" },
  { name: "Glasgow", country: "United Kingdom" },
  { name: "Hamburg", country: "Germany" },
  { name: "Helsinki", country: "Finland" },
  { name: "Hong Kong", country: "China" },
  { name: "Houston", state: "Texas", country: "United States" },
  { name: "Istanbul", country: "Turkey" },
  { name: "Jakarta", country: "Indonesia" },
  { name: "Johannesburg", country: "South Africa" },
  { name: "Kuala Lumpur", country: "Malaysia" },
  { name: "Kyoto", country: "Japan" },
  { name: "Las Vegas", state: "Nevada", country: "United States" },
  { name: "Lisbon", country: "Portugal" },
  { name: "London", country: "United Kingdom" },
  { name: "Los Angeles", state: "California", country: "United States" },
  { name: "Madrid", country: "Spain" },
  { name: "Manchester", country: "United Kingdom" },
  { name: "Manila", country: "Philippines" },
  { name: "Melbourne", country: "Australia" },
  { name: "Mexico City", country: "Mexico" },
  { name: "Miami", state: "Florida", country: "United States" },
  { name: "Milan", country: "Italy" },
  { name: "Montreal", province: "Quebec", country: "Canada" },
  { name: "Moscow", country: "Russia" },
  { name: "Mumbai", country: "India" },
  { name: "Munich", country: "Germany" },
  { name: "Nashville", state: "Tennessee", country: "United States" },
  { name: "New Orleans", state: "Louisiana", country: "United States" },
  { name: "New York", state: "New York", country: "United States" },
  { name: "Osaka", country: "Japan" },
  { name: "Oslo", country: "Norway" },
  { name: "Ottawa", province: "Ontario", country: "Canada" },
  { name: "Paris", country: "France" },
  { name: "Philadelphia", state: "Pennsylvania", country: "United States" },
  { name: "Phoenix", state: "Arizona", country: "United States" },
  { name: "Portland", state: "Oregon", country: "United States" },
  { name: "Prague", country: "Czech Republic" },
  { name: "Rio de Janeiro", country: "Brazil" },
  { name: "Rome", country: "Italy" },
  { name: "San Diego", state: "California", country: "United States" },
  { name: "San Francisco", state: "California", country: "United States" },
  { name: "Santiago", country: "Chile" },
  { name: "São Paulo", country: "Brazil" },
  { name: "Seattle", state: "Washington", country: "United States" },
  { name: "Seoul", country: "South Korea" },
  { name: "Shanghai", country: "China" },
  { name: "Singapore", country: "Singapore" },
  { name: "Stockholm", country: "Sweden" },
  { name: "Sydney", country: "Australia" },
  { name: "Taipei", country: "Taiwan" },
  { name: "Tel Aviv", country: "Israel" },
  { name: "Tokyo", country: "Japan" },
  { name: "Toronto", province: "Ontario", country: "Canada" },
  { name: "Vancouver", province: "British Columbia", country: "Canada" },
  { name: "Venice", country: "Italy" },
  { name: "Vienna", country: "Austria" },
  { name: "Warsaw", country: "Poland" },
  { name: "Washington D.C.", country: "United States" },
  { name: "Wellington", country: "New Zealand" },
  { name: "Zurich", country: "Switzerland" }
];

async function seedCities() {
  // Insert cities in batches of 20
  const batchSize = 20;
  for (let i = 0; i < citiesData.length; i += batchSize) {
    const batch = citiesData.slice(i, i + batchSize);
    
    console.log(`Inserting batch ${i / batchSize + 1}/${Math.ceil(citiesData.length / batchSize)}`);
    
    const { data, error } = await supabase
      .from('cities')
      .upsert(batch, { 
        onConflict: 'name, country',  // Avoid duplicates
        ignoreDuplicates: true 
      });
    
    if (error) {
      console.error('Error inserting cities:', error);
      return;
    }
  }
  
  console.log('All cities inserted successfully!');
}

// Run the seed function
seedCities().catch(console.error);
