class AuthService {
  // Pre-configured Admin credentials
  static const String adminEmail = "admin@pets.com";
  static const String adminPass = "admin123";
  static const String adminSecretKey = "PETSADMIN2026";

  // Login handler
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required bool isAdmin,
    String? adminKey,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (isAdmin) {
      if (email.trim().toLowerCase() == adminEmail && password == adminPass) {
        if (adminKey != adminSecretKey) {
          return {'success': false, 'message': 'Invalid Admin Secret Security Key'};
        }
        return {'success': true, 'role': 'admin'};
      }
      return {'success': false, 'message': 'Invalid Admin Credentials (use admin@pets.com / admin123)'};
    } else {
      if (email.contains('@') && password.length >= 6) {
        return {'success': true, 'role': 'user'};
      }
      return {'success': false, 'message': 'Enter a valid email and minimum 6-character password'};
    }
  }

  // Sign up handler
  static Future<Map<String, dynamic>> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required bool isAdmin,
    String? adminKey,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (isAdmin && adminKey != adminSecretKey) {
      return {'success': false, 'message': 'Invalid Admin Secret Key. Registration denied.'};
    }

    return {'success': true, 'message': 'Account created successfully!'};
  }
}