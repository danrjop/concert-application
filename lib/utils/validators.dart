class Validators {
  // Email validation
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegex.hasMatch(email);
  }

  // Password validation (minimum 8 characters, at least one letter and one number)
  static bool isValidPassword(String password) {
    if (password.length < 8) return false;
    
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    
    return hasLetter && hasNumber;
  }
  
  // Username validation (alphanumeric, 3-20 characters)
  static bool isValidUsername(String username) {
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
    return usernameRegex.hasMatch(username);
  }
  
  // URL validation
  static bool isValidUrl(String url) {
    final urlRegex = RegExp(
      r'^(http|https)://[a-zA-Z0-9-_.]+\.[a-zA-Z]{2,}[a-zA-Z0-9-_./?=&#]*$',
    );
    return urlRegex.hasMatch(url);
  }
  
  // Credit card validation
  static bool isValidCreditCard(String creditCardNumber) {
    // Remove spaces and dashes
    final cleanedNumber = creditCardNumber.replaceAll(RegExp(r'[\s-]'), '');
    
    // Check if it contains only digits and has a valid length
    if (!RegExp(r'^[0-9]{13,19}$').hasMatch(cleanedNumber)) {
      return false;
    }
    
    // Luhn algorithm for checksum validation
    int sum = 0;
    bool alternate = false;
    
    for (int i = cleanedNumber.length - 1; i >= 0; i--) {
      int n = int.parse(cleanedNumber[i]);
      
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n = (n % 10) + 1;
        }
      }
      
      sum += n;
      alternate = !alternate;
    }
    
    return sum % 10 == 0;
  }
  
  // Phone number validation (simple pattern matching)
  static bool isValidPhoneNumber(String phoneNumber) {
    // Remove spaces, dashes, and parentheses
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[\s\-()]'), '');
    
    // Allow international prefix
    final phoneRegex = RegExp(r'^(\+?[0-9]{8,15})$');
    return phoneRegex.hasMatch(cleanedNumber);
  }
}
