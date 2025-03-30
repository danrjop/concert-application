// A list of popular cities for users to select as their home city
class Cities {
  static const List<String> popularCities = [
    "Amsterdam", "Athens", "Atlanta", "Auckland", "Austin",
    "Bangkok", "Barcelona", "Beijing", "Berlin", "Boston", "Brussels", "Buenos Aires",
    "Cairo", "Cape Town", "Chicago", "Copenhagen",
    "Dallas", "Delhi", "Denver", "Detroit", "Dubai", "Dublin",
    "Edinburgh",
    "Frankfurt",
    "Glasgow",
    "Hamburg", "Helsinki", "Hong Kong", "Houston",
    "Istanbul",
    "Jakarta", "Johannesburg",
    "Kuala Lumpur", "Kyoto",
    "Las Vegas", "Lisbon", "London", "Los Angeles",
    "Madrid", "Manchester", "Manila", "Melbourne", "Mexico City", "Miami", "Milan", "Montreal", "Moscow", "Mumbai", "Munich",
    "Nashville", "New Orleans", "New York",
    "Osaka", "Oslo", "Ottawa",
    "Paris", "Philadelphia", "Phoenix", "Portland", "Prague",
    "Rio de Janeiro", "Rome",
    "San Diego", "San Francisco", "Santiago", "São Paulo", "Seattle", "Seoul", "Shanghai", "Singapore", "Stockholm", "Sydney",
    "Taipei", "Tel Aviv", "Tokyo", "Toronto",
    "Vancouver", "Venice", "Vienna",
    "Warsaw", "Washington D.C.", "Wellington",
    "Zurich"
  ];

  // Search for cities that match the given query
  static List<String> search(String query) {
    if (query.isEmpty) {
      return [];
    }
    final lowercaseQuery = query.toLowerCase();
    return popularCities.where(
      (city) => city.toLowerCase().contains(lowercaseQuery)
    ).toList();
  }
}
