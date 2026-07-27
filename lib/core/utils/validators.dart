/// Standard regex validation checks (teck-stack.md §4)
abstract class Validators {
  static final RegExp _phoneRegex = RegExp(r'^[6-9]\d{9}$');
  static final RegExp _otpRegex = RegExp(r'^\d{4}$'); // Indian OTP is 4-digit (resolved contradiction)
  static final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  /// Verify if phone is valid 10-digit Indian number starting with 6-9
  static bool isValidPhone(String phone) {
    return _phoneRegex.hasMatch(phone);
  }

  /// Verify if OTP matches 4-digit specification
  static bool isValidOtp(String otp) {
    return _otpRegex.hasMatch(otp);
  }

  /// Verify if email is properly formatted (if provided)
  static bool isValidEmail(String email) {
    if (email.trim().isEmpty) return true; // Optional field
    return _emailRegex.hasMatch(email);
  }

  /// Verify if manual fare falls inside ₹1 to ₹99,999 bounds
  static bool isValidFare(double fare) {
    return fare >= 1.0 && fare <= 99999.0;
  }
}
