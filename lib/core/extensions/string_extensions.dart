/// Convenient String extensions for basic checks
extension StringExtensions on String {
  bool get isNullOrEmpty => trim().isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;
}
