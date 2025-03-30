class City {
  final String id;
  final String name;
  final String? state;
  final String? province;
  final String country;
  
  City({
    required this.id,
    required this.name,
    this.state,
    this.province,
    required this.country,
  });

  // Format the display name based on location info
  String get displayName {
    if (state != null && state!.isNotEmpty) {
      return '$name, $state, $country';
    } else if (province != null && province!.isNotEmpty) {
      return '$name, $province, $country';
    } else {
      return '$name, $country';
    }
  }

  // Short display name (city and state/province only)
  String get shortDisplayName {
    if (state != null && state!.isNotEmpty) {
      return '$name, $state';
    } else if (province != null && province!.isNotEmpty) {
      return '$name, $province';
    } else {
      return name;
    }
  }

  // Convert city to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state': state,
      'province': province,
      'country': country,
    };
  }

  // Create city from JSON
  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      state: json['state'],
      province: json['province'],
      country: json['country'],
    );
  }
}
