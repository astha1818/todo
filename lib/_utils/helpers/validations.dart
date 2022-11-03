class Validation {
  static String? titleValidation(String? text) {
    String title = text ?? '';
    if (title.trim().isEmpty) return 'AppStrings.emptyName';
    return null;
  }
}
